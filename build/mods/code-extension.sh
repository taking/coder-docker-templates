#!/bin/bash

mkdir -p /tmp/extensions
curl -L "https://github.com/taking/coder-docker-templates/releases/download/v0.1/extensions.tgz" | tar -C /tmp/extensions -xzvf -


# Dev
/tmp/code-server/bin/code-server --install-extension /tmp/extensions/vincaslt.highlight-matching-tag-0.11.0.vsix
/tmp/code-server/bin/code-server --install-extension /tmp/extensions/naumovs.color-highlight-2.5.0.vsix
/tmp/code-server/bin/code-server --install-extension /tmp/extensions/dzhavat.bracket-pair-toggler-0.0.3.vsix
/tmp/code-server/bin/code-server --install-extension /tmp/extensions/formulahendry.auto-close-tag-0.5.14.vsix
/tmp/code-server/bin/code-server --install-extension /tmp/extensions/formulahendry.auto-rename-tag-0.1.10.vsix
/tmp/code-server/bin/code-server --install-extension /tmp/extensions/donjayamanne.githistory-0.6.20.vsix
/tmp/code-server/bin/code-server --install-extension /tmp/extensions/seatonjiang.gitmoji-vscode-1.2.4.vsix
/tmp/code-server/bin/code-server --install-extension /tmp/extensions/eamodio.gitlens-13.5.0.vsix
/tmp/code-server/bin/code-server --install-extension /tmp/extensions/Gruntfuggly.todo-tree-0.0.226.vsix
/tmp/code-server/bin/code-server --install-extension /tmp/extensions/wayou.vscode-todo-highlight-1.0.5.vsix
/tmp/code-server/bin/code-server --install-extension /tmp/extensions/usernamehw.errorlens-3.8.0.vsix
/tmp/code-server/bin/code-server --install-extension /tmp/extensions/redhat.vscode-yaml-1.14.0.vsix
/tmp/code-server/bin/code-server --install-extension /tmp/extensions/vscjava.vscode-gradle-3.12.2023092801.vsix


# Code Server
/tmp/code-server/bin/code-server --install-extension /tmp/extensions/RoscoP.ActiveFileInStatusBar-1.0.3.vsix
/tmp/code-server/bin/code-server --install-extension /tmp/extensions/oderwat.indent-rainbow-8.3.1.vsix
/tmp/code-server/bin/code-server --install-extension /tmp/extensions/mkxml.vscode-filesize-3.1.0.vsix
/tmp/code-server/bin/code-server --install-extension /tmp/extensions/SimonSiefke.svg-preview-2.8.3.vsix

# Language
/tmp/code-server/bin/code-server --install-extension /tmp/extensions/MS-CEINTL.vscode-language-pack-ko-1.76.0.vsix

# Theme & Icon
/tmp/code-server/bin/code-server --install-extension /tmp/extensions/zhuangtongfa.Material-theme-3.16.0.vsix
/tmp/code-server/bin/code-server --install-extension /tmp/extensions/vscode-icons-team.vscode-icons-12.5.0.vsix

cat <<EOF > $HOME/.local/share/code-server/User/settings.json
{
  "remote.SSH.defaultExtensions": [
    "vincaslt.highlight-matching-tag",
    "naumovs.color-highlight",
    "dzhavat.bracket-pair-toggler",
    "formulahendry.auto-close-tag",
    "formulahendry.auto-rename-tag",
    "donjayamanne.githistory",
    "seatonjiang.gitmoji-vscode",
    "Gruntfuggly.todo-tree",
    "wayou.vscode-todo-highlight",
    "eamodio.gitlens",
    "redhat.vscode-yaml",
    "vscjava.vscode-gradle"
  ],

  "editor.fontFamily": "Hack, D2Coding, Consolas, Menlo, Monaco, 'Courier New', monospace",
  "editor.fontSize": 14,
  "editor.tabSize": 2,
  "editor.wordWrap": "on",
  "editor.wrappingIndent": "indent",
  "editor.fontLigatures": true,
  "editor.rulers": [100, 120],
  "editor.cursorBlinking": "phase",
  "editor.guides.indentation": true,
  "editor.codeActionsOnSave": {
  
  },
  "editor.lineHeight" : 26,
  "editor.suggestSelection" : "first",
  "editor.renderLineHighlight" : "gutter",
  "editor.suggest.showStatusBar": true,
  "files.eol": "\n",
  "terminal.integrated.fontSize": 18,
  "terminal.integrated.fontWeightBold": "bold",
  "ActiveFileInStatusBar.enable": true,
  "ActiveFileInStatusBar.fullpath": true,
  "ActiveFileInStatusBar.revealFile": false,
  
  // Theme & Icon Start
  "workbench.iconTheme": "vscode-icons",
  "workbench.colorTheme": "One Dark Pro Darker",
  "workbench.statusBar.visible": true,
  "workbench.activityBar.visible": true,
  "vsicons.dontShowNewVersionMessage": true,  // vscode-icons
  // Theme & Icon Stop

  // "editor.formatOnSave": false,
  "security.workspace.trust.untrustedFiles": "open",

  // Gitlens Start
  "gitlens.changes.toggleMode": "file",
  "gitlens.defaultDateLocale": "ko-KR",
  "gitlens.defaultDateFormat": "YYYY-MM-DD H:MM:mm",
  "gitlens.codeLens.scopes": [
    "document",
    "containers"
  ],
  "gitlens.advanced.messages": {
      "suppressShowKeyBindingsNotice": true
  },
  // Gitlens End

  // auto-close-tag Start
  "auto-close-tag.SublimeText3Mode": true,
  "auto-close-tag.activationOnLanguage": [
      "html",
      "xml",
      "php",
      "css",        
      "javascript",
      "js",
      "vue"
  ],
  // auto-close-tag End

  // indentRainbow Start
  "indentRainbow.ignoreErrorLanguages" : [
    "markdown"
  ],
  // indentRainbow End

  // Gitmoji Start
  "gitmoji.additionalEmojis": [
    {
      "emoji": "🐛",
      "code": ":bug:",
      "description": "Fix a bug.",
      "description_ko_kr": "BUG 수정","remote.SSH.remotePlatform": {"coder-vscode--taking--nw":"linux","coder-vscode--taking--gedge--main":"linux","coder-vscode--taking--nw--main":"linux"}
    },
    {
      "emoji": "🚑",
      "code": ":ambulance:",
      "description": "Critical hotfix.",
      "description_zh_cn": "크리티컬 긴급수정"
    }
  ],
  // Gitmoji End

  // Google Style Guide (Java) Start
  "java.format.settings.url": "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml",
  "java.format.settings.profile": "GoogleStyle"
  // Google Style Guide End
}
EOF
