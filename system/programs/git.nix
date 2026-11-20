{ lib, pkgs, config, username, ... }:

let
  secretsEnabled = config.secrets.enable or false;
  usingSops = secretsEnabled && config.sops.gitConfig.enable;
in
{
  options.sops.gitConfig = {
    enable = lib.mkEnableOption "Enable Git config via SOPS templates";
  };

  # The rest of the git config is in home/programs/git.nix
  config = lib.mkIf usingSops {
    environment.systemPackages = with pkgs; [ sops age ];

    sops.templates."gitconfig" = {
      content = ''
        [user]
            name  = ${config.sops.placeholder.git_username}
            email = ${config.sops.placeholder.git_email}
      '';
      owner = username;
      mode   = "0600";
    };

    home-manager.users.${username}.programs.git.includes = [
      { path = config.sops.templates."gitconfig".path; }
    ];
  };
}
