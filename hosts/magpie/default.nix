# Custom Settings for each user/pc that might be very individual. It only needs the import of ./hardware-configuration.nix as a bare minimum.
{
  pkgs,
  username,
  nixos-hardware,
  ...
}:

{
  imports = [
    ./config.nix
    ./hardware-configuration.nix
    ./kanshi.nix

    # nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen5
  ];

  secrets.enable = true;

  users.users.${username}.packages = with pkgs; [
    steam
    discord

    android-studio
    antigravity-fhs
    arduino-ide
    ausweisapp
    bitwarden-desktop
    element-desktop
    freecad
    fwupd # install Firmware updates
    marktext # markdown editor
    nextcloud-client
    obsidian
    onlyoffice-desktopeditors # microsoft-like text documents
    qemu
    signal-desktop
    simple-scan # gnome scanner
    spotify
    # texliveFull
    zotero

    eog
    evince
    gnome-sound-recorder
    gnome-text-editor

    cargo
    tldr
    python3

    yazi
  ];

  programs.nix-ld.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Thinkpad Specific Power Management Features
  # services.thermald.enable = true;

  # Fingerprintreader
  #services.fprintd.enable = true;

  # Enable zramSwap to avoid using a large disk partition.
  # Since you have ~64GB RAM, capping ZRAM at 25% provides ~16GB of highly compressed swap.
  zramSwap = {
    enable = true;
    memoryPercent = 25;
  };

  # Pin on Linux Version X
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
