# Firefox is a webbrowser
{
  config,
  lib,
  username,
  ...
}:
let
  cfg = config.modules.apps.firefox;
in
{
  options.modules.apps.firefox = {
    enable = lib.mkEnableOption "firefox";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${username} =
      { ... }:
      let
        extension = shortId: guid: {
          "${guid}" = {
            install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
            installation_mode = "force_installed";
          };
        };
      in
      {
        programs.firefox = {
          enable = true;
          configPath = ".mozilla/firefox";

          profiles.default = {
            isDefault = true;

            settings = {
              # Form autofill
              "browser.formfill.enable" = false;
              "forms.autocomplete.enabled" = false;
              "signon.autofillForms" = false;

              # Password saving
              "signon.rememberSignons" = false;
              "signon.generation.enabled" = false;

              # Form/search history
              "browser.formfill.remember" = false;
              "browser.history.folders.enabled" = false;

              # Vertical tabs (native Firefox sidebar)
              "sidebar.verticalTabs" = true;
              "sidebar.revamp" = true;

              # Other Zen-like defaults (from your original config)
              "extensions.autoDisableScopes" = 0;
              "extensions.pocket.enabled" = false;

              # Spellcheck: German + English
              "layout.spellcheckDefault" = 2; # 0=off, 1=inline, 2=bottom window
              "spellchecker.dictionary" = "de-DE,en-US";

              # Optional: Enable multilingual spellcheck
              "layout.spellcheckDefaultMultilingual" = true;

              "widget.wayland.fractional-scale.enabled" = true;
              # "layout.css.devPixelsPerPx" = -1.0; # Auto-detect Scale (oder 1/1.5 = 0.6667)
              # "gfx.webrender.all" = true;
              # "widget.non-native-theme.enabled" = true; # GTK-Theme ignorieren für konsistente Icons
            };

            search = {
              force = true; # Required to override default Firefox engines
              default = "ddg";
              engines = {
                "nixpkgs packages" = {
                  urls = [ { template = "https://search.nixos.org/packages?query={searchTerms}"; } ];
                  icon = "https://wiki.nixos.org/favicon.ico";
                  definedAliases = [ "@np" ];
                };

                "NixOS options" = {
                  urls = [ { template = "https://search.nixos.org/options?query={searchTerms}"; } ];
                  icon = "https://wiki.nixos.org/favicon.ico";
                  definedAliases = [ "@no" ];
                };
                "NixOS Wiki" = {
                  urls = [ { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; } ];
                  icon = "https://wiki.nixos.org/favicon.ico";
                  definedAliases = [ "@nw" ];
                };
                "Home Manager Options" = {
                  urls = [ { template = "https://home-manager-options.extranix.com/?query={searchTerms}"; } ];
                  icon = "https://home-manager-options.extranix.com/favicon.ico";
                  definedAliases = [ "@nh" ];
                };
                "noogle" = {
                  urls = [ { template = "https://noogle.dev/q?term={searchTerms}"; } ];
                  icon = "https://noogle.dev/favicon.ico";
                  definedAliases = [ "@ng" ];
                };
                "Youtube" = {
                  urls = [ { template = "https://www.youtube.com/results?search_query={searchTerms}"; } ];
                  icon = "https://youtube.com/favicon.ico";
                  definedAliases = [ "@yt" ];
                };
                "GitHub Repo Search" = {
                  urls = [ { template = "https://github.com/search?q={searchTerms}&type=repositories"; } ];
                  icon = "https://github.com/favicon.ico";
                  definedAliases = [ "@gh" ];
                };
                "Perplexity" = {
                  urls = [ { template = "https://www.perplexity.ai/search?focus=internet&q=%{searchTerms}"; } ];
                  icon = "https://www.perplexity.ai/favicon.ico";
                  definedAliases = [ "@pp" ];
                };
                "Codeberg Repositories" = {
                  urls = [
                    {
                      template = "https://codeberg.org/explore/repos?q={searchTerms}&only_show_relevant=true&sort=recentupdate";
                    }
                  ];
                  icon = "https://codeberg.org/favicon.ico";
                  definedAliases = [ "@cb" ];
                };
                "Crates IO" = {
                  urls = [ { template = "https://crates.io/search?q={searchTerms}"; } ];
                  icon = "https://crates.io/favicon.ico";
                  definedAliases = [ "@rs" ];
                };
                "Wikipedia (EN)" = {
                  urls = [ { template = "https://en.wikipedia.org/w/index.php?search={searchTerms}"; } ];
                  icon = "https://en.wikipedia.org/favicon.ico";
                  definedAliases = [ "@we" ];
                };
                "Wikipedia (DE)" = {
                  urls = [ { template = "https://de.wikipedia.org/w/index.php?search={searchTerms}"; } ];
                  icon = "https://de.wikipedia.org/favicon.ico";
                  definedAliases = [ "@wd" ];
                };
                "Amazon (DE)" = {
                  urls = [ { template = "https://www.amazon.de/s?k={searchTerms}"; } ];
                  icon = "https://www.amazon.de/favicon.ico";
                  definedAliases = [ "@az" ];
                };
                "Google Scholar" = {
                  urls = [ { template = "https://scholar.google.com/scholar?q={searchTerms}"; } ];
                  icon = "https://scholar.google.com/favicon.ico";
                  definedAliases = [ "@gs" ];
                };
                "Thesaurus" = {
                  urls = [ { template = "https://www.thesaurus.com/browse/{searchTerms}"; } ];
                  icon = "https://www.thesaurus.com/favicon.ico";
                  definedAliases = [ "@th" ];
                };
              };
            };
          };

          policies = {
            DisableTelemetry = true;

            ExtensionSettings = {
              # "*".installation_mode = "blocked";
            }
            // (extension "ublock-origin" "uBlock0@raymondhill.net")
            // (extension "bitwarden-password-manager" "{446900e4-71c2-419f-a6a7-df9c091e268b}")
            // (extension "sponsorblock" "sponsorBlocker@ajay.app");
          };
        };
      };
  };
}
