terraform {
  required_providers {
    coder = {
      source  = "coder/coder"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
    }
  }
}

locals {
  folder_name = try(element(split("/", data.coder_parameter.repo.value), length(split("/", data.coder_parameter.repo.value)) - 1), "")  
  repo_owner_name = try(element(split("/", data.coder_parameter.repo.value), length(split("/", data.coder_parameter.repo.value)) - 2), "")
}

provider "coder" {
}

variable "host" {
  description = "Cluster host address"
  sensitive   = true
}

variable "cluster_ca_certificate" {
  description = "Cluster CA certificate (base64 encoded)"
  sensitive   = true
}

variable "token" {
  description = "Cluster CA token (base64 encoded)"
  sensitive   = true
}

variable "namespace" {
  description = "Namespace"
}


data "coder_parameter" "cpu" {
  name         = "cpu"
  display_name = "CPU"
  description  = "The number of CPU cores"
  default      = "2"
  icon         = "/icon/memory.svg"
  mutable      = true
  option {
    name  = "2 Cores"
    value = "2"
  }
  option {
    name  = "4 Cores"
    value = "4"
  }
  option {
    name  = "6 Cores"
    value = "6"
  }
  option {
    name  = "8 Cores"
    value = "8"
  }
}

data "coder_parameter" "memory" {
  name         = "memory"
  display_name = "Memory"
  description  = "The amount of memory in GB"
  default      = "2"
  icon         = "/icon/memory.svg"
  mutable      = true
  option {
    name  = "2 GB"
    value = "2"
  }
  option {
    name  = "4 GB"
    value = "4"
  }
  option {
    name  = "6 GB"
    value = "6"
  }
  option {
    name  = "8 GB"
    value = "8"
  }
}

data "coder_parameter" "home_disk_size" {
  name         = "home_disk_size"
  display_name = "Home disk size"
  description  = "The size of the home disk in GB"
  default      = "10"
  type         = "number"
  icon         = "/emojis/1f4be.png"
  mutable      = false
  validation {
    min = 1
    max = 99999
  }
}

data "coder_parameter" "repo" {
  name        = "Source Code Repository (optional)"
  display_name= "Source Code Repository (optional)"
  description = "What source code repository do you want to clone?"
  default     = "https://github.com/taking/java-spring-base-structure"
  type        = "string"
  icon        = "https://git-scm.com/images/logos/downloads/Git-Icon-1788C.png"
  mutable     = true
}

data "coder_parameter" "language" {
  name        = "Use Language (Optional)"
  display_name= "Use Language (Optional)"
  description = "What do you use to language?"
  default     = "python"
  type        = "string"
  icon        = "https://git-scm.com/images/logos/downloads/Git-Icon-1788C.png"
  mutable     = true  
  option {
    name  = "python"
    value = "python"
  }
  option {
    name  = "go (latest)"
    value = "go"
  }
  option {
    name  = "rust (latest)"
    value = "rust"
  }
  option {
    name  = "java (Temurin OpenJDK 21)"
    value = "java"
  }
  option {
    name  = "node (20.15.1, LTS)"
    value = "node"
  }
}

provider "kubernetes" {
  host                   = var.host
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
  token                  = base64decode(var.token)
}

data "coder_workspace" "me" {}
data "coder_workspace_owner" "me" {}

resource "coder_agent" "main" {
  os                     = "linux"
  arch                   = "amd64"
  # startup_script         = <<-EOT
  #   set -e

  #   # install and start code-server
  #   curl -fsSL https://code-server.dev/install.sh | sh -s -- --method=standalone --prefix=/tmp/code-server --version 4.11.0
  #   /tmp/code-server/bin/code-server --auth none --port 13337 >/tmp/code-server.log 2>&1 &
  # EOT

  # The following metadata blocks are optional. They are used to display
  # information about your workspace in the dashboard. You can remove them
  # if you don't want to display any information.
  # For basic resources, you can use the `coder stat` command.
  # If you need more control, you can write your own script.
  metadata {
    display_name = "CPU Usage"
    key          = "0_cpu_usage"
    script       = "coder stat cpu"
    interval     = 10
    timeout      = 1
  }

  metadata {
    display_name = "RAM Usage"
    key          = "1_ram_usage"
    script       = "coder stat mem"
    interval     = 10
    timeout      = 1
  }

  metadata {
    display_name = "Home Disk"
    key          = "3_home_disk"
    script       = "coder stat disk --path $${HOME}"
    interval     = 60
    timeout      = 1
  }

  metadata {
    display_name = "CPU Usage (Host)"
    key          = "4_cpu_usage_host"
    script       = "coder stat cpu --host"
    interval     = 10
    timeout      = 1
  }

  metadata {
    display_name = "Memory Usage (Host)"
    key          = "5_mem_usage_host"
    script       = "coder stat mem --host"
    interval     = 10
    timeout      = 1
  }

  metadata {
    display_name = "Load Average (Host)"
    key          = "6_load_host"
    # get load avg scaled by number of cores
    script   = <<EOT
      echo "`cat /proc/loadavg | awk '{ print $1 }'` `nproc`" | awk '{ printf "%0.2f", $1/$2 }'
    EOT
    interval = 60
    timeout  = 1
  }
  
  metadata {
    display_name = "Weather"
    key  = "weather"
    # for more info: https://github.com/chubin/wttr.in
    script = <<EOT
        curl -s 'wttr.in/seul?format=3' 2>&1 | awk '{print}'
    EOT
    interval = 600
    timeout = 10
  }

  startup_script_behavior = "blocking"
  startup_script = <<EOT
#!/bin/bash

# install and start code-server
curl -fsSL https://code-server.dev/install.sh | sh -s -- --method=standalone --prefix=/tmp/code-server --version 4.11.0
/tmp/code-server/bin/code-server --auth none --port 13337 >/tmp/code-server.log 2>&1 &

# clone repo
if test -z "${data.coder_parameter.repo.value}" 
then
  echo "No git repo specified, skipping"
else
  if [[ ! -d "${local.folder_name}" ]] 
  then
    mkdir -p $HOME/workspaces

    echo "Cloning git repo..."
    git clone ${data.coder_parameter.repo.value}

    mv $HOME/${local.folder_name} $HOME/workspaces/${local.folder_name}
  else
    echo "Repo ${data.coder_parameter.repo.value} already exists. Will not reclone"
  fi
  cd $HOME/workspaces/${local.folder_name}
fi

# Install oh-my-zsh from container image
curl -fsSL https://raw.githubusercontent.com/taking/taking/main/mySettings/scripts/ohmyzsh_install.sh | bash

# Function to install Python (placeholder)
install_python() {
  echo "Python installation is not defined in this script."
}

# Function to install Go
install_go() {
  curl -fsSL https://raw.githubusercontent.com/taking/taking/main/mySettings/scripts/go_install.sh | bash
  go install -v golang.org/x/tools/gopls@latest
}

# Function to install Rust
install_rust() {
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

# Function to install Java
install_java() {
  curl -fsSL https://raw.githubusercontent.com/taking/taking/main/mySettings/scripts/java21_install.sh | bash
}

# Function to install Node.js
install_node() {
  curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n | bash -s 20.15.1
}

# Install language from container image
case "${data.coder_parameter.language.value}" in
  "python")
    install_python
    ;;
  "go")
    install_go
    ;;
  "rust")
    install_rust
    ;;
  "java")
    install_java
    ;;
  "node")
    install_node
    ;;
  *)
    echo "Unsupported language: ${data.coder_parameter.language.value}"
    ;;
esac

Function to install Base VS Code Extenstions
ext_install_base() {
  curl -fsSL https://raw.githubusercontent.com/taking/taking/main/mySettings/scripts/vs_code_ext_install.sh | bash
}

ext_install_base

# # Install language from container image
# case "${data.coder_parameter.language.value}" in
#   "python")
#     ;;
#   "go")
#     ;;
#   "rust")
#     ;;
#   "java")
#     ;;
#   "node")
#     ;;
#   *)
#     echo "Unsupported language: ${data.coder_parameter.language.value}"
#     ;;
# esac
  EOT
}

# code-server
resource "coder_app" "code-server" {
  agent_id     = coder_agent.main.id
  slug         = "code-server"
  display_name = "code-server"
  icon         = "/icon/code.svg"
  url          = "http://localhost:13337?folder=/home/coder"
  subdomain    = false
  share        = "owner"

  healthcheck {
    url       = "http://localhost:13337/healthz"
    interval  = 3
    threshold = 10
  }
}

resource "kubernetes_persistent_volume_claim" "home" {
  metadata {
    name      = "coder-${lower(data.coder_workspace_owner.me.name)}-${lower(data.coder_workspace.me.name)}-home"
    namespace = var.namespace
    labels = {
      "app.kubernetes.io/name"     = "coder-pvc"
      "app.kubernetes.io/instance" = "coder-pvc-${lower(data.coder_workspace_owner.me.name)}-${lower(data.coder_workspace.me.name)}"
      "app.kubernetes.io/part-of"  = "coder"
      // Coder specific labels.
      "com.coder.resource"       = "true"
      "com.coder.workspace.id"   = data.coder_workspace.me.id
      "com.coder.workspace.name" = data.coder_workspace.me.name
      "com.coder.user.id"        = data.coder_workspace_owner.me.id
      "com.coder.user.username"  = data.coder_workspace_owner.me.name
    }
    annotations = {
      "com.coder.user.email" = data.coder_workspace_owner.me.email
    }
  }
  wait_until_bound = false
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "${data.coder_parameter.home_disk_size.value}Gi"
      }
    }
  }
}

resource "coder_metadata" "workspace_info" {
  count       = data.coder_workspace.me.start_count
  resource_id = kubernetes_deployment.main[0].id
  item {
    key   = "image"
    value = "codercom/enterprise-base:ubuntu"
  }
  item {
    key   = "language"
    value = "${data.coder_parameter.language.value}"
  }
  item {
    key   = "repo cloned"
    value = "${local.repo_owner_name}/${local.folder_name}"
  }   
}

resource "kubernetes_deployment" "main" {
  count = data.coder_workspace.me.start_count
  depends_on = [
    kubernetes_persistent_volume_claim.home
  ]
  wait_for_rollout = false
  metadata {
    name      = "coder-${lower(data.coder_workspace_owner.me.name)}-${lower(data.coder_workspace.me.name)}"
    namespace = var.namespace
    labels = {
      "app.kubernetes.io/name"     = "coder-workspace"
      "app.kubernetes.io/instance" = "coder-workspace-${lower(data.coder_workspace_owner.me.name)}-${lower(data.coder_workspace.me.name)}"
      "app.kubernetes.io/part-of"  = "coder"
      "com.coder.resource"         = "true"
      "com.coder.workspace.id"     = data.coder_workspace.me.id
      "com.coder.workspace.name"   = data.coder_workspace.me.name
      "com.coder.user.id"          = data.coder_workspace_owner.me.id
      "com.coder.user.username"    = data.coder_workspace_owner.me.name
    }
    annotations = {
      "com.coder.user.email" = data.coder_workspace_owner.me.email
    }
  }

  
  spec {
    replicas = 1
    selector {
      match_labels = {
        "app.kubernetes.io/name" = "coder-workspace"
      }
    }
    strategy {
      type = "Recreate"
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" = "coder-workspace"
        }
      }
      spec {
        security_context {
          run_as_user = 1000
          fs_group    = 1000
        }

        container {
          name    = "coder-container"
          image   = "codercom/enterprise-base:ubuntu"
          image_pull_policy = "Always"
          command           = ["sh", "-c", coder_agent.main.init_script]
          security_context {
            run_as_user = "1000"
          }
          env {
            name  = "CODER_AGENT_TOKEN"
            value = coder_agent.main.token
          }
          resources {
            requests = {
              "cpu"    = "250m"
              "memory" = "512Mi"
            }
            limits = {
              "cpu"    = "${data.coder_parameter.cpu.value}"
              "memory" = "${data.coder_parameter.memory.value}Gi"
            }
          }
          volume_mount {
            mount_path = "/home/coder"
            name       = "home"
            read_only  = false
          }
        }

        volume {
          name = "home"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.home.metadata.0.name
            read_only  = false
          }
        }

        affinity {
          // This affinity attempts to spread out all workspace pods evenly across
          // nodes.
          pod_anti_affinity {
            preferred_during_scheduling_ignored_during_execution {
              weight = 1
              pod_affinity_term {
                topology_key = "kubernetes.io/hostname"
                label_selector {
                  match_expressions {
                    key      = "app.kubernetes.io/name"
                    operator = "In"
                    values   = ["coder-workspace"]
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
