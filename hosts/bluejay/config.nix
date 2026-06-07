{
  username,
  ...
}:
{
  modules = {
    desktop.enable = true;

    powerManagement.profile = "tlp";

    desktop.walker.bitwarden.enable = false;

    services.storage.enable = true;
    # programs.udiskie.enable = true;

    apps = {
      android-studio.enable = true;
      ausweisapp.enable = true;
      firefox.enable = true;
      thunderbird.enable = true;
      # mullvad.enable = true;
      vscode.enable = true;
    };
  };

  # Enable Sops and Sops-Connected Modules
  secrets.enable = true;
  sops = {
    gitConfig.enable = true;
  };
}
