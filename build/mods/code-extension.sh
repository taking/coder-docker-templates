#!/bin/bash

mkdir -p /tmp/extensions
curl -L "https://github.com/taking/coder-docker-templates/releases/download/v0.1/extensions.tgz" | tar -C /tmp/extensions -xzvf -

/tmp/code-server/bin/code-server --install-extension /tmp/extensions/donjayamanne.githistory-0.6.20.vsix
/tmp/code-server/bin/code-server --install-extension /tmp/extensions/formulahendry.auto-close-tag-0.5.14.vsix
/tmp/code-server/bin/code-server --install-extension /tmp/extensions/formulahendry.auto-rename-tag-0.1.10.vsix
/tmp/code-server/bin/code-server --install-extension /tmp/extensions/mkxml.vscode-filesize-3.1.0.vsix
/tmp/code-server/bin/code-server --install-extension /tmp/extensions/oderwat.indent-rainbow-8.3.1.vsix
/tmp/code-server/bin/code-server --install-extension /tmp/extensions/seatonjiang.gitmoji-vscode-1.2.4.vsix
/tmp/code-server/bin/code-server --install-extension /tmp/extensions/tal7aouy.theme-3.1.0.vsix
/tmp/code-server/bin/code-server --install-extension /tmp/extensions/vscode-icons-team.vscode-icons-12.5.0.vsix
