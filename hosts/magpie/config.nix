{
  username,
  ...
}:
{
  modules = {
    desktop.enable = true;

    powerManagement.profile = "tlp";

    hardware.lenovo-amd.enable = true;

    services.storage.enable = true;

    apps = {
      # android-studio.enable = true;
      ausweisapp.enable = true;
      # mullvad.enable = true;
      # swaync.enable = true;
      docker.enable = true;
    };
  };

  # Enable Sops and Sops-Connected Modules
  secrets.enable = true;
  sops = {
    gitConfig.enable = true;
  };
}
