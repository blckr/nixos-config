# Git is a tool for verioncontrol
{ lib, pkgs, config, username, ... }:

let
  secretsEnabled = config.secrets.enable or false;
  usingSops = secretsEnabled && config.sops.gitConfig.enable;
in
{
  options.sops.gitConfig = {
    enable = lib.mkEnableOption "Enable Git config via SOPS templates";
  };

  config = lib.mkMerge [
    {
      environment.systemPackages = with pkgs; [ git ];
    }

    (lib.mkIf usingSops {
      environment.systemPackages = with pkgs; [ sops age ];

      sops.templates."gitconfig" = {
        content = ''
          [user]
              name  = ${config.sops.placeholder.git_username}
              email = ${config.sops.placeholder.git_email}

          [init]
              defaultBranch = main

          [pull]
              rebase = true

          [push]
              autoSetupRemote = true

          [core]
              editor = ${pkgs.helix}/bin/hx
        '';
        owner = username;
        mode   = "0600";
      };

      home-manager.users.${username}.programs.git = {
        enable   = true;
        includes = [ { path = config.sops.templates."gitconfig".path; } ];
      };
    })

    (lib.mkIf (! usingSops) {
      home-manager.users.${username}.programs.git = {
        enable    = true;
        userName  = "Default Name";
        userEmail = "you@example.com";
        extraConfig = {
          init = { defaultBranch = "main"; };
          core  = { editor = "${pkgs.helix}/bin/hx"; };
          pull  = { rebase = true; };
          push  = { autoSetupRemote = true; };
        };
      };
    })
  ];
}
