#!/bin/bash

jdk_folder="/usr/lib/jdk-17.0.7"

if [ -d "$jdk_folder" ]; then
  echo "java Exists"
else
  echo "java Installing"
  wget https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.7%2B7/OpenJDK17U-jdk_x64_linux_hotspot_17.0.7_7.tar.gz
  tar xvzf OpenJDK17U-jdk_x64_linux_hotspot_17.0.7_7.tar.gz
  sudo chown -R root:root jdk-17.0.7+7
  sudo mv jdk-17.0.7+7/ /usr/lib/jdk-17.0.7
  rm OpenJDK17U-jdk_x64_linux_hotspot_17.0.7_7.tar.gz


  cat <<'EOF' >> ~/.zshrc
export JAVA_HOME=/usr/lib/jdk-17.0.7
export PATH=$JAVA_HOME/bin/:$PATH
export CLASS_PATH=$JAVA_HOME/lib:$CLASS_PATH
EOF

fi
