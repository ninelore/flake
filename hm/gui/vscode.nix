{ pkgs, ... }:
let
  extensions =
    [
      # Workaround noncompliant names
      pkgs.open-vsx."13xforever".language-x86-64-assembly # MIT
    ]
    # nixpkgs-unstable-small
    ++ (with pkgs.pkgs-small; [
      vscode-extensions.charliermarsh.ruff # MIT
      vscode-extensions.ms-python.python # MIT
      vscode-extensions.rust-lang.rust-analyzer
      vscode-extensions.sumneko.lua # MIT & Apache 2.0
      vscode-extensions.vadimcn.vscode-lldb # MIT
    ])
    # Extension flake, updated nightly
    # Open VSX
    ++ (with pkgs.open-vsx; [
      # TODO: Audit Licences, but should be all FOSS
      aaron-bond.better-comments
      adpyke.codesnap
      angular.ng-template
      aperricone.regexper-unofficial
      arrterian.nix-env-selector
      augustocdias.tasks-shell-input
      bbenoist.doxygen
      bierner.markdown-mermaid
      bpruitt-goddard.mermaid-markdown-syntax-highlighting
      brunnerh.insert-unicode
      budparr.language-hugo-vscode
      cheshirekow.cmake-format
      christian-kohler.npm-intellisense
      christian-kohler.path-intellisense
      codezombiech.gitignore
      cschlosser.doxdocgen
      davidanson.vscode-markdownlint
      dbaeumer.vscode-eslint
      donjayamanne.githistory
      dotjoshjohnson.xml
      eamodio.gitlens
      ecmel.vscode-html-css
      editorconfig.editorconfig
      #esbenp.prettier-vscode
      fill-labs.dependi
      firefox-devtools.vscode-firefox-debug
      formulahendry.auto-rename-tag
      formulahendry.code-runner
      foxundermoon.shell-format
      franneck94.c-cpp-runner
      franneck94.vscode-c-cpp-config
      franneck94.vscode-c-cpp-dev-extension-pack
      franneck94.vscode-coding-tools-extension-pack
      franneck94.vscode-python-config
      franneck94.vscode-python-dev-extension-pack
      franneck94.vscode-rust-config
      franneck94.vscode-rust-extension-pack
      franneck94.vscode-typescript-extension-pack
      franneck94.workspace-formatter
      github.vscode-github-actions
      github.vscode-pull-request-github
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
      ms-azuretools.vscode-docker
      ms-python.isort
      ms-python.mypy-type-checker
      ms-vscode.cmake-tools
      ms-vscode.hexeditor
      ms-vscode.makefile-tools
      mtxr.sqltools
      mtxr.sqltools-driver-mysql
      mtxr.sqltools-driver-pg
      mtxr.sqltools-driver-sqlite
      njqdev.vscode-python-typehint
      njpwerner.autodocstring
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
      sainnhe.sonokai
      smcpeak.default-keys-windows
      tamasfe.even-better-toml
      tauri-apps.tauri-vscode
      thenuprojectcontributors.vscode-nushell-lang
      timonwong.shellcheck
      tomoki1207.pdf
      tonybaloney.vscode-pets
      twxs.cmake
      unifiedjs.vscode-mdx
      usernamehw.errorlens
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
    ])
    # Visual Studio Marketplace, IMPORTANT: FOSS only!
    ++ (with pkgs.vscode-marketplace; [
      ambar.bundle-size # MIT
      chrmarti.regex # MIT
      chukwuamaka.csvtojson-converter # MIT
      joshuapoehls.json-escaper # MIT
      kricsleo.vscode-package-json-inspector # MIT
      mike-co.import-sorter # MIT
      nimda.deepdark-material # MIT
      oracle-labs-graalvm.visualvm-vscode # GPL2
      pmneo.tsimporter # MIT
      quicktype.quicktype # Apache 2.0
      ryu1kn.partial-diff # MIT
      thog.vscode-asl # MIT
      #tinkertrain.theme-panda # Licence unclear. MIT according to issues
    ]);
in
{
  programs.vscode = {
    inherit extensions;
    enable = true;
    package = pkgs.pkgs-small.vscodium;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    mutableExtensionsDir = false;
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
      "typescript.updateImportsOnFileMove.enabled" = "always";
      "update.showReleaseNotes" = false;
      "visualvm.installation.visualvmPath" = pkgs.visualvm;
      "window.titleBarStyle" = "custom";
      "workbench.colorTheme" = "Sonokai Shusia";
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
    };
  };
}
