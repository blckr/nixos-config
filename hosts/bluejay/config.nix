{
  username,
  ...
}:
{
  modules = {
    desktop.enable = true;

    powerManagement.profile = "tlp";

    services.storage.enable = true;
    # programs.udiskie.enable = true;

    apps = {
      android-studio.enable = true;
      ausweisapp.enable = true;
      # mullvad.enable = true;
    };
  };

  # Enable Sops and Sops-Connected Modules
  secrets.enable = true;
  sops = {
    gitConfig.enable = true;
  };
}
