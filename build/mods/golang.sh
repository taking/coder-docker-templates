#!/bin/bash

go_folder="/usr/local/go"

if [ -d "$go_folder" ]; then
  echo "go Exists"
else
  echo "go Installing"
  curl -L "https://go.dev/dl/go1.21.2.linux-amd64.tar.gz" | sudo tar -C /usr/local -xzvf -

  cat <<'EOF' >> ~/.zshrc
export GO_ROOT=/usr/local/go
export PATH=$PATH:$GO_ROOT/bin
export GO_PATH=$HOME/go
export GO_BIN=$GO_PATH/bin
export PATH=$PATH:$GO_BIN
EOF

  echo 'deb [trusted=yes] https://repo.goreleaser.com/apt/ /' | sudo tee /etc/apt/sources.list.d/goreleaser.list
  sudo apt-get update && sudo apt-get install goreleaser -y

fi

