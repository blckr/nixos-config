{
  # When using auto-generated hardware-configuration.nix this will enable microcode updates
  hardware.enableRedistributableFirmware = true;

  # Installs fwupd, a D-Bus-Service that updated Firmware
  services.fwupd.enable = true;
}
