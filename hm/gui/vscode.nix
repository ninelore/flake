{ pkgs, ... }:
let
  ovsx =
    with pkgs;
    [
      open-vsx."13xforever".language-x86-64-assembly
      vscode-extensions.ms-vscode.cpptools
      vscode-extensions.ms-vscode.cmake-tools
    ]
    ++ (with pkgs.open-vsx; [
      aaron-bond.better-comments
      adpyke.codesnap
      angular.ng-template
      aperricone.regexper-unofficial
      arrterian.nix-env-selector
      augustocdias.tasks-shell-input
      bbenoist.doxygen
      brunnerh.insert-unicode
      budparr.language-hugo-vscode
      cheshirekow.cmake-format
      christian-kohler.npm-intellisense
      christian-kohler.path-intellisense
      codezombiech.gitignore
      continue.continue
      cschlosser.doxdocgen
      davidanson.vscode-markdownlint
      dbaeumer.vscode-eslint
      donjayamanne.githistory
      dotjoshjohnson.xml
      eamodio.gitlens
      ecmel.vscode-html-css
      editorconfig.editorconfig
      fill-labs.dependi
      firefox-devtools.vscode-firefox-debug
      formulahendry.auto-rename-tag
      formulahendry.code-runner
      foxundermoon.shell-format
      franneck94.c-cpp-runner
      franneck94.vscode-c-cpp-config
      franneck94.vscode-c-cpp-dev-extension-pack
      franneck94.vscode-coding-tools-extension-pack
      franneck94.vscode-rust-config
      franneck94.vscode-rust-extension-pack
      franneck94.vscode-typescript-extension-pack
      franneck94.workspace-formatter
      github.vscode-github-actions
      github.vscode-pull-request-github
      glenn2223.live-sass
      golang.go
      hediet.vscode-drawio
      htmlhint.vscode-htmlhint
      janisdd.vscode-edit-csv
      jeanp413.open-remote-ssh
      jeff-hykin.better-cpp-syntax
      jnoortheen.nix-ide
      llvm-vs-code-extensions.vscode-clangd
      mads-hartmann.bash-ide-vscode
      mechatroner.rainbow-csv
      mikestead.dotenv
      mkhl.direnv
      mongodb.mongodb-vscode
      mrmlnc.vscode-scss
      ms-vscode.hexeditor
      ms-vscode.makefile-tools
      mtxr.sqltools
      mtxr.sqltools-driver-mysql
      mtxr.sqltools-driver-pg
      mtxr.sqltools-driver-sqlite
      pflannery.vscode-versionlens
      pinage404.nix-extension-pack
      piousdeer.adwaita-theme
      pkief.material-icon-theme
      redhat.fabric8-analytics
      redhat.java
      redhat.vscode-microprofile
      redhat.vscode-quarkus
      redhat.vscode-xml
      redhat.vscode-yaml
      rokoroku.vscode-theme-darcula
      rusnasonov.vscode-hugo
      rust-lang.rust-analyzer
      sainnhe.sonokai
      smcpeak.default-keys-windows
      sumneko.lua
      tamasfe.even-better-toml
      tauri-apps.tauri-vscode
      thenuprojectcontributors.vscode-nushell-lang
      timonwong.shellcheck
      tomoki1207.pdf
      tonybaloney.vscode-pets
      twxs.cmake
      unifiedjs.vscode-mdx
      usernamehw.errorlens
      vadimcn.vscode-lldb
      vscjava.vscode-java-debug
      vscjava.vscode-java-dependency
      vscjava.vscode-java-pack
      vscjava.vscode-java-test
      vscjava.vscode-maven
      vue.volar
      yoavbls.pretty-ts-errors
      yzhang.markdown-all-in-one
      zebreus.sconfig-extension
      zguolee.tabler-icons
      zignd.html-css-class-completion
    ]);
  vs-market = with pkgs.vscode-marketplace; [
    # agutierrezr.vscode-essentials # Maybe trial
    ahmadalli.vscode-nginx-conf
    ambar.bundle-size
    chrmarti.regex
    chukwuamaka.csvtojson-converter
    fabiospampinato.vscode-monokai-night
    idered.npm
    johnsoncodehk.vscode-tsconfig-helper
    joshuapoehls.json-escaper
    kricsleo.vscode-package-json-inspector
    leizongmin.node-module-intellisense
    mike-co.import-sorter
    nimda.deepdark-material
    oracle-labs-graalvm.visualvm-vscode
    pmneo.tsimporter
    platformio.platformio-ide
    quicktype.quicktype
    raynigon.nginx-formatter
    ryu1kn.partial-diff
    thog.vscode-asl
    tinkertrain.theme-panda
    vitaliymaz.vscode-svg-previewer
  ];
in
{
  programs.vscode = {
    enable = true;
    package = pkgs.pkgs-small.vscodium;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    mutableExtensionsDir = false;
    extensions = ovsx ++ vs-market;
    keybindings = [
      {
        key = "ctrl+y";
        command = "-editor.action.deleteLines";
        when = "editorTextFocus && !editorReadonly";
      }
      {
        key = "ctrl+s";
        command = "-workbench.action.files.save";
      }
      {
        key = "ctrl+s";
        command = "workbench.action.files.saveFiles";
      }
      {
        key = "f5";
        "command" = "sqltools.executeCurrentQuery";
        "when" = "editorTextFocus && editorLangId == sql";
      }
    ];
    userSettings = {
      "[css]" = {
        "editor.defaultFormatter" = "vscode.css-language-features";
      };
      "[html]" = {
        "editor.defaultFormatter" = "vscode.html-language-features";
      };
      "[java]" = {
        "editor.defaultFormatter" = "redhat.java";
      };
      "[javascript]" = {
        "editor.defaultFormatter" = "vscode.typescript-language-features";
      };
      "[json]" = {
        "editor.defaultFormatter" = "vscode.json-language-features";
      };
      "[jsonc]" = {
        "editor.defaultFormatter" = "vscode.json-language-features";
      };
      "[markdown]" = {
        "editor.defaultColorDecorators" = true;
        "editor.defaultFormatter" = "yzhang.markdown-all-in-one";
        "editor.formatOnPaste" = true;
        "editor.formatOnSave" = true;
        "editor.wordWrap" = "wordWrapColumn";
        "editor.wordWrapColumn" = 120;
      };
      "[rust]" = {
        "editor.defaultFormatter" = "rust-lang.rust-analyzer";
      };
      "[scss]" = {
        "editor.defaultFormatter" = "vscode.css-language-features";
      };
      "[typescript]" = {
        "editor.defaultFormatter" = "vscode.typescript-language-features";
      };
      "[xml]" = {
        "editor.defaultFormatter" = "redhat.vscode-xml";
      };
      "[yaml]" = {
        "editor.defaultFormatter" = "redhat.vscode-yaml";
      };
      "cmake.configureOnOpen" = true;
      "cmake.pinnedCommands" = [
        "workbench.action.tasks.configureTaskRunner"
        "workbench.action.tasks.runTask"
      ];
      "cmake.showConfigureWithDebuggerNotification" = false;
      "cmake.showOptionsMovedNotification" = false;
      "debug.onTaskErrors" = "debugAnyway";
      "debug.openDebug" = "openOnDebugBreak";
      "diffEditor.hideUnchangedRegions.enabled" = true;
      "diffEditor.maxComputationTime" = 0;
      "diffEditor.renderSideBySide" = false;
      "editor.accessibilitySupport" = "off";
      "editor.fontFamily" = "'JetBrainsMono Nerd Font Propo', 'JetBrainsMono Nerd Font', 'JetBrains Mono', Fira Code, Consolas, monospace";
      "editor.guides.bracketPairs" = true;
      "editor.guides.highlightActiveIndentation" = "always";
      "editor.indentSize" = "tabSize";
      "editor.linkedEditing" = true;
      "editor.multiCursorLimit" = 100000;
      "editor.rulers" = [
        80
        120
      ];
      "editor.stickyScroll.enabled" = true;
      "editor.stickyTabStops" = true;
      "editor.tabCompletion" = "on";
      "editor.tabSize" = 2;
      "editor.unicodeHighlight.nonBasicASCII" = false;
      "editor.wordSeparators" = "`~!@#$%^&*()-=+[{]}\\|;:'\",.<>/?";
      "emmet.showAbbreviationSuggestions" = false;
      "explorer.confirmDelete" = false;
      "extensions.supportUntrustedWorkspaces" = {
        "k--kato.intellij-idea-keybindings" = {
          supported = true;
          version = "";
        };
      };
      "files.defaultLanguage" = "";
      "git.autofetch" = true;
      "git.confirmSync" = false;
      "git.enableSmartCommit" = true;
      "git.ignoreRebaseWarning" = true;
      "git.openRepositoryInParentFolders" = "never";
      "githubPullRequests.createOnPublishBranch" = "never";
      "githubPullRequests.pullBranch" = "never";
      "gitlens.advanced.messages" = {
        suppressLineUncommittedWarning = true;
      };
      "gitlens.blame.avatars" = false;
      "gitlens.plusFeatures.enabled" = false;
      "gitlens.showWhatsNewAfterUpgrades" = false;
      "gitlens.telemetry.enabled" = false;
      "hediet.vscode-drawio.resizeImages" = null;
      "htmlhint.options" = {
        attr-lowercase = false;
      };
      "importSorter.importStringConfiguration.tabSize" = 2;
      "java.debug.settings.showQualifiedNames" = true;
      "javascript.updateImportsOnFileMove.enabled" = "always";
      "keyboard.dispatch" = "keyCode";
      "liveSassCompile.settings.useNewCompiler" = true;
      "makefile.configureOnOpen" = true;
      "markdownlint.config" = {
        MD033 = false;
        MD034 = false;
      };
      "maven.executable.preferMavenWrapper" = true;
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nixd";
      "nix.serverSettings" = {
        nixd = {
          formatting = {
            command = [ "nixfmt" ];
          };
        };
      };
      "quarkus.tools.alwaysShowWelcomePage" = false;
      "quarkus.tools.debug.terminateProcessOnExit" = "Always terminate";
      "quarkus.tools.starter.showExtensionDescriptions" = true;
      "redhat.telemetry.enabled" = false;
      "rust-analyzer.debug.engineSettings" = { };
      "sqltools.format" = {
        linesBetweenQueries = "preserve";
      };
      "telemetry.telemetryLevel" = "off";
      "terminal.integrated.autoReplies" = {
        "Terminate batch job (Y/N)" = "Y\r";
      };
      "terminal.integrated.defaultProfile.linux" = "Nushell";
      "terminal.integrated.automationProfile.linux" = {
        "path" = "${pkgs.nushell}/bin/nu";
      };
      "typescript.updateImportsOnFileMove.enabled" = "always";
      "update.showReleaseNotes" = false;
      "visualvm.installation.visualvmPath" = "/home/9l/.visualvm/visualvm_218";
      "window.titleBarStyle" = "custom";
      "workbench.colorTheme" = "Panda Syntax";
      "workbench.editor.empty.hint" = "hidden";
      "workbench.editor.wrapTabs" = true;
      "workbench.editorAssociations" = {
        "*.dtb" = "hexEditor.hexedit";
      };
      "workbench.iconTheme" = "material-icon-theme";
      "workbench.productIconTheme" = "Tabler";
      "workbench.startupEditor" = "none";
      "workbench.tree.indent" = 12;
      "zenMode.hideActivityBar" = false;
      "C_Cpp.intelliSenseEngine" = "disabled";
      "platformio-ide.useBuiltinPython" = false;
    };
  };
}
