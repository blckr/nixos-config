{
  pkgs,
  username,
  inputs,
  lib,
  config,
  ...
}:
let
  cfg = config.modules.desktop.walker;
in
{
  options.modules.desktop.walker = {
    bitwarden.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Bitwarden extension for Walker";
    };
  };

  config = lib.mkIf config.modules.desktop.enable {
    home-manager.users.${username} = {
      imports = [ inputs.walker.homeManagerModules.default ];

      home.packages =
        with pkgs;
        [
          wtype
          wl-clipboard
          libnotify
          sqlite
        ]
        ++ lib.optional cfg.bitwarden.enable rbw;

      home.file.".config/elephant/websearch.toml".text = ''
        [[entries]]
        default = true
        name = "DuckDuckGo"
        url = "https://duckduckgo.com/?q=%TERM%"
      '';

      programs.rbw = lib.mkIf cfg.bitwarden.enable {
        enable = true;
        settings = {
          email = config.sops.placeholder.primary_email;
          # lock_timeout = 3600;
          lock_timeout = 36000;
          pinentry = pkgs.pinentry-gnome3;
        };
      };

      xdg.configFile."rbw/config.json".enable = false;

      programs.walker = {
        enable = true;
        runAsService = true;

        config = {
          terminal = "${pkgs.kitty}/bin/kitty";
          theme = "ayu-mirage";
          force_keyboard_focus = false;
          close_when_open = true;
          click_to_close = true;
          as_window = false;
          single_click_activation = true;
          selection_wrap = false;
          global_argument_delimiter = "#";
          exact_search_prefix = "'";
          disable_mouse = false;
          debug = true;

          shell = {
            exclusive_zone = -1;
            layer = "overlay";
          };

          keybinds = {
            close = [ "Escape" ];
            next = [ "Down" ];
            previous = [ "Up" ];
            left = [ "Left" ];
            right = [ "Right" ];
            toggle_exact = [ "ctrl e" ];
            resume_last_query = [ "ctrl r" ];
          };

          providers = {
            default = [
              "desktopapplications"
              "calc"
              "websearch"
              "bookmarks"
            ]
            ++ lib.optional cfg.bitwarden.enable "bitwarden";
            empty = [ "desktopapplications" ];
            max_results = 50;

            bookmarks = {
              path = "/home/arved/.mozilla/firefox/default/places.sqlite";
            };

            prefixes = [
              {
                provider = "runner";
                prefix = ">";
              }
              {
                provider = "files";
                prefix = "/";
              }
              {
                provider = "symbols";
                prefix = ".";
              }
              {
                provider = "calc";
                prefix = "=";
              }
              {
                provider = "websearch";
                prefix = "@";
              }
              {
                provider = "clipboard";
                prefix = ":";
              }
              {
                provider = "playerctl";
                prefix = "~";
              }
              {
                provider = "bookmarks";
                prefix = "%";
              }
              {
                provider = "windows";
                prefix = "$";
              }
            ]
            ++ lib.optional cfg.bitwarden.enable {
              provider = "bitwarden";
              prefix = "?";
            };
          };
        };

        themes = {
          "ayu-mirage" = {
            style = ''
              @define-color bg #212733;
              @define-color fg #d9d7ce;
              @define-color accent #ffad66;
              @define-color selection #343f4c;
              @define-color border #343f4c;

              * {
                all: unset;
                font-family: "JetBrainsMono Nerd Font";
                font-size: 16px;
              }

              .window {
                background-color: transparent;
              }

              .box-wrapper {
                background-color: @bg;
                border: 2px solid @accent;
                padding: 20px;
                border-radius: 4px;
                box-shadow: 0 20px 50px rgba(0, 0, 0, 0.6);
                min-width: 600px;
                min-height: 400px;
              }

              .input {
                color: @fg;
                background-color: #191e2a;
                padding: 15px;
                margin-bottom: 20px;
                border: 1px solid @accent;
                caret-color: @accent;
                font-size: 18px;
              }

              .input placeholder {
                opacity: 0.4;
                color: @fg;
              }

              .list {
                color: @fg;
              }

              .item-box {
                padding: 12px 20px;
                margin: 4px 0;
                transition: background-color 200ms ease;
              }

              child:selected .item-box,
              row:selected .item-box {
                background-color: @selection;
                border-left: 2px solid @accent;
              }

              .item-text {
                font-weight: bold;
                margin-left: 15px;
                color: @fg;
              }

              .item-subtext {
                font-size: 13px;
                opacity: 0.5;
                margin-left: 15px;
                color: @fg;
              }

              .preview {
                border: 1px solid @border;
                padding: 15px;
                margin-left: 15px;
                background-color: #191e2a;
                color: @fg;
              }

              .calc .item-text {
                color: @accent;
                font-size: 24px;
              }

              /* ── Actions ── */
              .keybinds-wrapper {
                border: 1px solid alpha(@border, 0.45);
                background-color: #191e2a;
                border-radius: 4px;
                padding: 6px 12px;
                margin-top: 10px;
                opacity: 0.75;
              }

              .keybind {
                padding: 2px 8px;
                margin: 2px 0;
              }

              .keybind-bind {
                color: @accent;
                font-size: 11px;
                font-weight: bold;
                background-color: alpha(@accent, 0.10);
                border: 1px solid alpha(@accent, 0.30);
                border-radius: 3px;
                padding: 1px 5px;
                margin-right: 4px;
              }

              .keybind-label {
                color: @fg;
                font-size: 11px;
                opacity: 0.45;
              }
            '';
          };
        };
      };
    };
  };
}
