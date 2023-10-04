#!/bin/bash

go_folder="/usr/local/go"

if [ -d "$go_folder" ]; then
  echo "go Exists"
else
  echo "go Installing"
  curl -L "https://go.dev/dl/go1.21.1.linux-amd64.tar.gz" | tar -C /usr/local -xzvf -

  cat <<'EOF' >> ~/.zshrc
export GO_ROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN
EOF

  echo 'deb [trusted=yes] https://repo.goreleaser.com/apt/ /' | tee /etc/apt/sources.list.d/goreleaser.list
  apt-get update && apt-get install goreleaser -y

fi
