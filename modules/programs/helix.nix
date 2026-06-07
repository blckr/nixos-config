{
  username,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    lazygit
    rust-analyzer
  ];
  environment.variables.EDITOR = "hx";
  environment.variables.VISUAL = "hx";

  home-manager.users.${username} =
    { ... }:
    {
      programs.helix = {
        enable = true;
        defaultEditor = true;

        themes = {
          noctalia-custom = {
            inherits = "noctalia";
            "punctuation" = "outline";
            "punctuation.special" = "outline";
          };
        };

        settings = {
          theme = "noctalia-custom";

          editor = {
            auto-format = true;
            completion-replace = true;
            trim-final-newlines = true;
            trim-trailing-whitespace = true;
            end-of-line-diagnostics = "hint";
            inline-diagnostics = {
              cursor-line = "hint";
              other-lines = "warning";
            };
            lsp.display-inlay-hints = true;

            whitespace = {
              render = "all";

              characters = {
                tab = "→";
                space = "·";
              };
            };

            line-number = "relative";
            bufferline = "always";

            soft-wrap = {
              enable = true;
              max-wrap = 25;
              max-indent-retain = 5;
            };

            cursor-shape = {
              normal = "block";
              insert = "bar";
              select = "block";
            };
          };

          keys.normal = {
            "C-n" = ":sh ~/.config/helix/open-blame-github %{buffer_name} %{cursor_line}";
            "C-v" =
              ":sh git log -n 5 --format='format:%%h (%%an: %%ar) %%s' --no-patch -L%{cursor_line},+1:%{buffer_name}";
            "C-m" = [
              ":write-all"
              ":new"
              ":insert-output lazygit"
              ":buffer-close!"
              ":redraw"
              ":reload-all"
            ];
          };
        };

        languages = {
          language = [
            {
              name = "nix";
              formatter = {
                command = "nixfmt-rfc-style";
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
      };

      home.file.".config/helix/open-blame-github" = {
        executable = true;
        text = /* sh */ ''
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
