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

가능한 모드
- oh-my-zsh.sh (default)
- code-extension.sh (default)
- golang.sh
- java.sh
- node.sh

main.tf
```
# install java
    /home/${data.coder_workspace.me.owner}/mods/java.sh
```

## code-server

Create Workspace `yes | coder create --template="docker" {workspace_name}`


## etc
java 의 경우 다음의 확장 기능을 설치하시오.
- Extension Pack for Java
- Gradle for Java
- Language Support for Java(TM) by Red Hat
- Lombok Annotations Supports for VS Code
- Spring Boot Extension Pack

node 의 경우 다음의 확장 기능을 설치하시오.
- Auto Import
- Import Cost
- Prettier - Code formatter
- Version Lens
