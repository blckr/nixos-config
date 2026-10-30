{ pkgs, ... }:
{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      nil
      nixd
      rust-analyzer
      clang-tools
      gopls
      pyright
      bash-language-server
      typescript-language-server
      yaml-language-server
      vscode-langservers-extracted
      marksman
    ];

    settings = {
      theme = "nord";

      editor = {
        auto-format = true;
        completion-replace = true;
        trim-final-newlines = true;
        trim-trailing-whitespace = true;
        end-of-line-diagnostics = "hint";
        inline-diagnostics = {
          cursor-line = "warning";
          other-lines = "disable";
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
    };

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
        nil = {
          config = {
            nix.flake = {
              autoArchive = true;
              # Evaluating large inputs (nixpkgs, home-manager) crashes nil
              autoEvalInputs = false;
            };
          };
        };
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
}
