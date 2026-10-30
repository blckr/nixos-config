{
  config,
  pkgs,
  ...
}:
{
  # networking.networkmanager.enable = true;

  # networking.wireless.iwd.enable = true;
  # networking.networkmanager.backend = "iwd";

  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openconnect
  ];

  environment.systemPackages = with pkgs; [
    wireguard-tools
    networkmanager
    networkmanagerapplet
    openconnect
  ];

  networking.firewall.checkReversePath = "loose";
  networking.firewall.allowedUDPPorts = [ 51820 ];
}
