#!/bin/bash

node_folder="/usr/local/n"

if [ -d "$node_folder" ]; then
  echo "node Exists"
else
  echo "node Installing"
  sudo mkdir -p /usr/local/n
  sudo chown -R $(whoami) /usr/local/n
  sudo mkdir -p /usr/local/bin /usr/local/lib /usr/local/include /usr/local/share
  sudo chown -R $(whoami) /usr/local/bin /usr/local/lib /usr/local/include /usr/local/share

  curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n | bash -s lts
  npm install -g http-server
  npm install -g yarn
fi
