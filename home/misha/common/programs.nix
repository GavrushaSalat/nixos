# User programs managed by home-manager
{ pkgs, config, ... }:
let
  ffProfileDir = ".config/mozilla/firefox/default";
in
{
  programs.home-manager.enable = true;

  programs.git.enable = true;

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-nightly-bin;
    profiles.Default = {
      id = 0;
      isDefault = true;
      path = "default";
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "svg.context-properties.content.enabled" = true;
        "userChrome.theme-material" = true;
        "browser.nova.enabled" = true;

        "browser.startup.page" = 3;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.aboutConfig.showWarning" = false;
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.widgets.weather.enabled" = false;
        "browser.newtabpage.activity-stream.improvesearch.handoffToAwesomebar" = false;
        "browser.bookmarks.showMobileBookmarks" = false;
        "browser.translations.automaticallyPopup" = false;
        "browser.contentblocking.category" = "standard";
        "findbar.highlightAll" = true;
        "browser.display.document_color_use" = 0;
        "layout.css.prefers-color-scheme.content-override" = 0;
        "browser.ml.chat.provider" = "https://claude.ai/new";
        "devtools.cache.disabled" = true;
        "network.dns.disablePrefetch" = true;
        "network.prefetch-next" = false;
        "network.http.speculative-parallel-limit" = 0;
      };
    };
  };

  programs.zathura = {
    enable = true;
    # Добавляем плагин для поддержки PDF (mupdf быстрее и качественнее poppler)
    extraConfig = ''
      include "/etc/zathurarc"
      
      # Бонус: цвета в стиле Catppuccin Mocha (раз уж я видел у тебя эту тему в kde)
      set default-bg "#1e1e2e"
      set default-fg "#cdd6f4"
      set statusbar-bg "#181825"
      set statusbar-fg "#cdd6f4"
      set inputbar-bg "#181825"
      set inputbar-fg "#cdd6f4"
      set notification-bg "#181825"
      set notification-fg "#cdd6f4"
      set notification-error-bg "#f38ba8"
      set notification-error-fg "#1e1e2e"
      set notification-warning-bg "#f9e2af"
      set notification-warning-fg "#1e1e2e"
      set highlight-color "#f9e2af"
      set highlight-active-color "#a6e3a1"
      set completion-bg "#313244"
      set completion-fg "#cdd6f4"
      set completion-highlight-bg "#89b4fa"
      set completion-highlight-fg "#1e1e2e"
      set recolor-lightcolor "#1e1e2e"
      set recolor-darkcolor "#cdd6f4"
    '';
  };


  home.file = {
    "${ffProfileDir}/chrome/dms-colors.css".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/DankMaterialShell/firefox.css";

    "${ffProfileDir}/chrome/userChrome.css".text = ''
      @import "dms-colors.css";

      :root {
        --cat-base: var(--md-sys-color-surface-container);
        --cat-mantle: var(--md-sys-color-surface-container-low);
        --cat-surface0: var(--md-sys-color-surface-container-high);
        --cat-surface1: var(--md-sys-color-surface-container-highest);
        --cat-text: var(--md-sys-color-on-surface);
        --cat-subtext: var(--md-sys-color-on-surface-variant);
        --cat-overlay: var(--md-sys-color-outline);
        --cat-accent: var(--md-sys-color-primary);

        --toolbar-background-color: var(--cat-base);
        --toolbar-text-color: var(--cat-text);
        --background-color-box: var(--cat-base);
        --color-accent-primary: var(--cat-accent);

        --tab-background-color-selected: var(--cat-surface0);
        --tab-selected-textcolor: var(--cat-text);
        --tab-background-color-hover: color-mix(in srgb, var(--cat-text) 8%, transparent);
        --tab-border-color-selected-leading: transparent;
        --tab-border-color-selected-trailing: transparent;
        --tab-selected-outline-color: transparent;
        --tab-loading-fill: var(--cat-accent);

        --toolbar-field-background-color: var(--cat-surface0);
        --toolbar-field-background-color-focus: var(--cat-surface0);
        --toolbar-field-color: var(--cat-text);
        --urlbar-box-background-color: color-mix(in srgb, var(--cat-text) 12%, transparent);

        --arrowpanel-background: var(--cat-base);
        --arrowpanel-color: var(--cat-text);
        --arrowpanel-border-color: var(--cat-surface0);

        --sidebar-background-color: var(--cat-mantle);
        --sidebar-text-color: var(--cat-text);

        --lwt-text-color: var(--cat-text);
        --toolbar-color: var(--cat-text);
        --toolbarbutton-icon-fill: var(--cat-subtext);
      }

      .titlebar-buttonbox-container,
      .titlebar-spacer {
        display: none;
      }
    '';

    "${ffProfileDir}/chrome/userContent.css".text = ''
      @import "dms-colors.css";

      @-moz-document url-prefix("http://"), url-prefix("https://"), url-prefix("file:") {
        :root:not(#a) {
          font-family: revert !important;
        }
      }

      @-moz-document url-prefix("about:") {
        :root {
          color-scheme: dark !important;
          --background-color-canvas: var(--md-sys-color-surface-container, #1e1e2e) !important;
          --background-color-box: var(--md-sys-color-surface-container-high, #313244) !important;
          --background-color-box-info: color-mix(in srgb, var(--md-sys-color-on-surface, #cdd6f4) 6%, transparent) !important;
          --text-color: var(--md-sys-color-on-surface, #cdd6f4) !important;
          color: var(--md-sys-color-on-surface, #cdd6f4) !important;
          --color-accent-primary: var(--md-sys-color-primary, #f5e0dc) !important;
          --color-accent-primary-hover: var(--md-sys-color-primary, #f5e0dc) !important;
          --color-accent-primary-active: var(--md-sys-color-primary, #f5e0dc) !important;
          --color-accent-primary-selected: var(--md-sys-color-primary, #f5e0dc) !important;
          --link-color: var(--md-sys-color-primary, #f5e0dc) !important;
          --button-background-color: color-mix(in srgb, var(--md-sys-color-on-surface, #cdd6f4) 12%, transparent) !important;
          --button-background-color-hover: color-mix(in srgb, var(--md-sys-color-on-surface, #cdd6f4) 18%, transparent) !important;
          --button-background-color-active: color-mix(in srgb, var(--md-sys-color-on-surface, #cdd6f4) 26%, transparent) !important;
        }
      }
    '';
  };

  # Neovim from unstable — installed directly to avoid wrapper incompatibility
  home.packages = [
    pkgs.unstable.neovim
    pkgs.jq
    pkgs.yq-go
  ];

  programs.zed-editor = {
    enable = true;
    package = pkgs.unstable.zed-editor;
    userSettings = {
      auto_update = false;
      format_on_save = "off";
      cli_default_open_behavior = "existing_window";
      project_panel.dock = "left";
      outline_panel.dock = "left";
      collaboration_panel.dock = "left";
      agent = {
        dock = "right";
        favorite_models = [ ];
        model_parameters = [ ];
      };
      git_panel.dock = "left";
      session.trust_all_worktrees = true;
      vim_mode = true;
      agent_servers = {
        codex-acp.type = "registry";
        claude-acp.type = "registry";
      };
      base_keymap = "JetBrains";
      icon_theme = {
        mode = "dark";
        light = "Zed (Default)";
        dark = "Zed (Default)";
      };
      ui_font_size = 16;
      buffer_font_size = 15;
      theme = {
        mode = "dark";
        light = "DankShell Light";
        dark = "DankShell Dark";
      };
    };
  };
  home.sessionVariables.EDITOR = "nvim";

  programs.ghostty = {
    enable = true;
    package = pkgs.unstable.ghostty;
    settings = {
      custom-shader = "~/.config/ghostty/shaders/cursor-warp.glsl";
      confirm-close-surface = false;
      theme = "dankcolors";
      keybind = [
        "ctrl+shift+key_c=copy_to_clipboard"
        "ctrl+shift+key_v=paste_from_clipboard"
      ];
    };
  };

  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    mouse = true;
    historyLimit = 50000;
    keyMode = "vi";
    extraConfig = ''
      set -g set-clipboard on
    '';
  };

  programs.btop = {
    enable = true;
    settings = {
      proc_sorting = "memory";
      show_battery = true;
      show_battery_watts = true;
      show_cpu_watts = true;
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/markdown" = "dev.zed.Zed.desktop";
      "application/json" = "dev.zed.Zed.desktop";
      "text/plain" = "dev.zed.Zed.desktop";
      "text/x-log" = "dev.zed.Zed.desktop";
      "application/yaml" = "dev.zed.Zed.desktop";
      "application/x-yaml" = "dev.zed.Zed.desktop";
      "application/toml" = "dev.zed.Zed.desktop";
      "text/xml" = "dev.zed.Zed.desktop";
      "application/xml" = "dev.zed.Zed.desktop";
      "text/csv" = "dev.zed.Zed.desktop";

      "text/x-python" = "dev.zed.Zed.desktop";
      "application/x-shellscript" = "dev.zed.Zed.desktop";
      "text/x-shellscript" = "dev.zed.Zed.desktop";
      "text/x-csrc" = "dev.zed.Zed.desktop";
      "text/x-chdr" = "dev.zed.Zed.desktop";
      "text/x-c++src" = "dev.zed.Zed.desktop";
      "text/x-c++hdr" = "dev.zed.Zed.desktop";
      "text/rust" = "dev.zed.Zed.desktop";
      "text/x-rust" = "dev.zed.Zed.desktop";
      "text/x-go" = "dev.zed.Zed.desktop";
      "text/x-java" = "dev.zed.Zed.desktop";
      "text/javascript" = "dev.zed.Zed.desktop";
      "application/javascript" = "dev.zed.Zed.desktop";
      "text/css" = "dev.zed.Zed.desktop";
      "text/x-lua" = "dev.zed.Zed.desktop";
      "text/x-sql" = "dev.zed.Zed.desktop";
      "text/x-ini" = "dev.zed.Zed.desktop";

      "image/png" = "org.kde.gwenview.desktop";
      "image/jpeg" = "org.kde.gwenview.desktop";
      "image/gif" = "org.kde.gwenview.desktop";
      "image/webp" = "org.kde.gwenview.desktop";
      "image/bmp" = "org.kde.gwenview.desktop";
      "image/tiff" = "org.kde.gwenview.desktop";
      "image/svg+xml" = "org.kde.gwenview.desktop";
      "image/avif" = "org.kde.gwenview.desktop";
      "image/heif" = "org.kde.gwenview.desktop";
      "image/x-icon" = "org.kde.gwenview.desktop";

      "video/mp4" = "vlc.desktop";
      "video/x-matroska" = "vlc.desktop";
      "video/webm" = "vlc.desktop";
      "video/quicktime" = "vlc.desktop";
      "video/x-msvideo" = "vlc.desktop";
      "video/mpeg" = "vlc.desktop";
      "video/3gpp" = "vlc.desktop";

      "audio/mpeg" = "vlc.desktop";
      "audio/flac" = "vlc.desktop";
      "audio/x-wav" = "vlc.desktop";
      "audio/ogg" = "vlc.desktop";
      "audio/aac" = "vlc.desktop";
      "audio/mp4" = "vlc.desktop";
      "audio/x-m4a" = "vlc.desktop";
      "audio/opus" = "vlc.desktop";

      "application/zip" = "org.kde.ark.desktop";
      "application/x-7z-compressed" = "org.kde.ark.desktop";
      "application/vnd.rar" = "org.kde.ark.desktop";
      "application/x-tar" = "org.kde.ark.desktop";
      "application/x-compressed-tar" = "org.kde.ark.desktop";
      "application/x-xz-compressed-tar" = "org.kde.ark.desktop";
      "application/x-bzip-compressed-tar" = "org.kde.ark.desktop";
      "application/gzip" = "org.kde.ark.desktop";

      "inode/directory" = "org.kde.dolphin.desktop";
      "application/pdf" = "org.pwmt.zathura.desktop";

      "text/html" = "firefox-nightly.desktop";
      "application/xhtml+xml" = "firefox-nightly.desktop";
      "x-scheme-handler/http" = "firefox-nightly.desktop";
      "x-scheme-handler/https" = "firefox-nightly.desktop";
      "x-scheme-handler/chrome" = "firefox-nightly.desktop";

      "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
      "x-scheme-handler/tonsite" = "org.telegram.desktop.desktop";
      "x-scheme-handler/claude" = "com.anthropic.Claude.desktop";
      "x-scheme-handler/claude-cli" = "claude-code-url-handler.desktop";
    };
  };
}
