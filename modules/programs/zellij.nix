{
  username,
  config,
  ...
}:

let
  zellijBaseConfig = /* kdl */ ''
    copy_on_select true;
    default_mode "locked";
    on_force_close "quit";

    keybinds {
      shared {
        bind "Alt h" "Alt Left" { MoveFocusOrTab "Left"; };
        bind "Alt l" "Alt Right" { MoveFocusOrTab "Right"; };
        bind "Alt j" "Alt Down" { MoveFocus "Down"; };
        bind "Alt k" "Alt Up" { MoveFocus "Up"; };
        bind "Alt f" { ToggleFloatingPanes; };
        bind "Alt n" { NewPane; };
        bind "Alt [" { PreviousSwapLayout; };
        bind "Alt ]" { NextSwapLayout; };
        bind "Alt t" { NewTab; };
      };
    };

    show_release_notes true;
    show_startup_tips false;

    pane_frames false;

    ui {
      pane_frames { hide_session_name true; };
    };
  '';
in
{
  home-manager.users.${username} =
    { pkgs, ... }:
    {
      programs.zellij = {
        enable = true;
        enableFishIntegration = true;
      };

      programs.fish = {
        enable = true;
        interactiveShellInit = ''
          if status is-interactive
            eval (zellij setup --generate-auto-start fish)
          end
        '';
      };

      home.file.".config/zellij/config.kdl" = {
        force = true;
        text = ''
          ${config.modules.theme.data.zellij}
          ${zellijBaseConfig}
        '';
      };
    };
}
