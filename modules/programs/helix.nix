{ username, pkgs, ... }:

let
  helixFullConfig = ''
    theme = "ayu_mirage_transparent"

    [editor]
    lsp.display-inlay-hints = true
    line-number = "relative"
    bufferline = "always"

    [editor.soft-wrap]
    enable = true
    max-wrap = 25

    [editor.whitespace]
    render = "all"

    [editor.whitespace.characters]
    tab = "→"
    space = "·"

    [keys.normal]
    "C-n" = ":sh ~/.config/helix/open-blame-github %{buffer_name} %{cursor_line}"
    "C-v" = ":sh git log -n 5 --format='format:%%h (%%an: %%ar) %%s' --no-patch -L%{cursor_line},+1:%{buffer_name}"
    "C-m" = [ ":write-all", ":new", ":insert-output lazygit", ":buffer-close!", ":redraw", ":reload-all" ]
  '';
in
{
  environment.systemPackages = with pkgs; [
    lazygit
    rust-analyzer
  ];
  environment.variables.EDITOR = "hx";
  environment.variables.VISUAL = "hx";

  home-manager.users.${username} =
    { config, pkgs, ... }:
    {
      programs.helix = {
        enable = true;
        defaultEditor = true;

        languages = {
          language = [
            {
              name = "nix";
              formatter = {
                command = "nixfmt";
              };
              auto-format = true;
            }
          ];
          language-server = {
            rust-analyzer = {
              config = {
                inlayHints = {
                  typeHints.enable = true;
                  parameterHints.enable = true;
                  chainingHints.enable = true;
                };
              };
            };
            gopls = {
              config = {
                hints = {
                  assignVariableTypes = true;
                  compositeLiteralFields = true;
                  compositeLiteralTypes = true;
                  constantValues = true;
                  functionTypeParameters = true;
                  parameterNames = true;
                  rangeVariableTypes = true;
                };
              };
            };
            pyright = {
              config = {
                python.analysis.inlayHints = {
                  callArgumentNames = true;
                  functionReturnTypes = true;
                  variableTypes = true;
                };
              };
            };
            clangd = {
              args = [ "--inlay-hints" ];
            };
          };
        };

        themes = {
          ayu_mirage_transparent = {
            "inherits" = "ayu_mirage";
            "ui.background" = { };
            "ui.linenr" = "gray";
            "ui.linenr.selected" = "foreground";
            "ui.whitespace" = {
              fg = "gray";
            };
            "ui.virtual.inlay-hint" = {
              fg = "#5c6773";
            };
            "ui.selection" = {
              bg = "#264563";
            };
          };

          ayu_light_transparent = {
            "inherits" = "ayu_light";
            "ui.background" = { };
            "ui.linenr" = "gray";
            "ui.linenr.selected" = "foreground";
            "ui.whitespace" = {
              fg = "gray";
            };
            "ui.virtual.inlay-hint" = {
              fg = "#8692a0ff";
            };
            "ui.selection" = {
              bg = "#b0c4b1";
            };

            palette = {
              orange = "#ce6d22ff";
              yellow = "#ff9500";
              green = "#08ad10";
            };
          };
        };
      };

      xdg.configFile."helix/config-base-nix.toml" = {
        text = helixFullConfig;
        onChange = ''
          rm -f ~/.config/helix/config.toml
          cp ~/.config/helix/config-base-nix.toml ~/.config/helix/config.toml
          chmod 644 ~/.config/helix/config.toml
        '';
      };

      home.file.".config/helix/open-blame-github" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash
          FILE="$1"
          LINE="$2"

          # Git Remote URL auslesen
          REMOTE_URL=$(git config --get remote.origin.url 2>/dev/null)

          if [ -z "$REMOTE_URL" ]; then
            echo "Kein Git-Repository gefunden"
            exit 1
          fi

          # URL normalisieren (ssh zu https konvertieren)
          if [[ $REMOTE_URL == git@* ]]; then
            HOST=$(echo "$REMOTE_URL" | grep -oP '(?<=@)[^:]+')
            REPO=$(echo "$REMOTE_URL" | grep -oP '(?<=:).*')
            REPO="''${REPO%.git}"

            case "$HOST" in
              codeberg-*) HOST="codeberg.org" ;;
              github-*) HOST="github.com" ;;
              gitlab-*) HOST="gitlab.com" ;;
            esac

            REMOTE_URL="https://$HOST/$REPO"
          else
            REMOTE_URL="''${REMOTE_URL%.git}"
          fi

          # Use provided line number or default to 1
          LINE="''${LINE:-1}"

          COMMIT=$(git blame -L $LINE,+1 -- "$FILE" 2>/dev/null | awk '{print $1}' | sed 's/\^//' | head -c 7)

          if [ -n "$COMMIT" ] && [ "$COMMIT" != "00000000" ]; then
            URL="''${REMOTE_URL}/commit/$COMMIT"
            xdg-open "$URL"
          else
            echo "Kein Commit gefunden"
          fi
        '';
      };
    };
}
