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

    nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen5
  ];

  home-manager.users.${username}.imports = [ ./home.nix ];

  secrets.enable = true;

  users.users.${username}.packages = with pkgs; [
    discord

    android-studio
    antigravity-fhs
    arduino-ide
    ausweisapp
    bitwarden-desktop
    element-desktop
    fwupd
    marktext
    nextcloud-client
    obsidian
    onlyoffice-desktopeditors
    qemu
    signal-desktop
    simple-scan
    spotify
    # texliveFull
    vscode
    zotero

    hoard

    eog
    evince
    gnome-sound-recorder
    gnome-text-editor

    cargo
    tldr
    python3
  ];

  programs.nix-ld.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  programs.ausweisapp.enable = true;
  programs.ausweisapp.openFirewall = true;

  services.thermald.enable = true;

  hardware.amdgpu.opencl.enable = true;

  #services.fprintd.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_6_18;
}
