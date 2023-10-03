---
name: Develop in Docker
description: Develop inside Docker containers using your local daemon
tags: [local, docker]
icon: /icon/docker.png
---

# docker

`git clone https://github.com/taking/coder-docker-templates`

## Editing the image

Edit the `Dockerfile`, `mods`, `main.tf` and run `yes | coder templates push` to update workspaces.


main.tf
```
# install java
    /home/${data.coder_workspace.me.owner}/mods/java.sh
```

## code-server

Create Workspace `yes | coder create --template="docker" {workspace_name}`

