{
  username,
  ...
}:
{
  modules = {
    theme.active = "nord";
    desktop.enable = true;
    desktop.niri.statusbar = "noctalia";

    powerManagement.profile = "tlp";

    desktop.walker.bitwarden.enable = false;

    hardware.lenovo-amd.enable = true;

    services.storage.enable = true;

    apps = {
      # android-studio.enable = true;
      ausweisapp.enable = true;
      firefox.enable = true;
      # mullvad.enable = true;
      vscode.enable = true;
      fnott.enable = false;
      # swaync.enable = true;
      container.enable = true;
    };
  };

  # Enable Sops and Sops-Connected Modules
  secrets.enable = true;
  sops = {
    gitConfig.enable = true;
  };
}
