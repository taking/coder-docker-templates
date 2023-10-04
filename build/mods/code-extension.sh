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

cat <<EOF > $HOME/.local/share/code-server/User/settings.json
{
  "editor.fontFamily": "Hack, D2Coding, Consolas, Menlo, Monaco, 'Courier New', monospace",
  "editor.fontSize": 17,
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
  "ActiveFileInStatusBar.enable": true,
  "ActiveFileInStatusBar.fullpath": true,
  "ActiveFileInStatusBar.revealFile": false,
  
  // Theme & Icon Start
  "workbench.iconTheme": "vscode-icons",
  "workbench.colorTheme": "Theme"
  "workbench.statusBar.visible": true,
  "workbench.activityBar.visible": true,
  "vsicons.dontShowNewVersionMessage": true,  // vscode-icons
  // Theme & Icon Stop

  // "editor.formatOnSave": false,

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
  "remote.SSH.remotePlatform": {"coder-vscode--taking--nw--main":"linux","coder-vscode--taking--nw":"linux","coder-vscode--taking--java":"linux"},
  "terminal.integrated.env.osx": {
    "FIG_NEW_SESSION": "1"
  }
  // Gitmoji End
}
EOF
