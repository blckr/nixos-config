{
  pkgs,
  pkgs-unstable,
  username,
  nixos-hardware,
  ...
}:

{
  imports = [
    ./config.nix
    ./hardware-configuration.nix

    # nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen5
  ];

  home-manager.users.${username}.imports = [ ./home.nix ];

  secrets.enable = true;

  users.users.${username}.packages = with pkgs; [
    steam
    discord

    gnome-obfuscate

    android-studio
    antigravity-fhs
    arduino-ide
    ausweisapp
    bitwarden-desktop
    element-desktop
    freecad
    fwupd
    marktext
    nextcloud-client
    obsidian
    onlyoffice-desktopeditors
    qemu
    pkgs-unstable.signal-desktop
    simple-scan
    spotify
    # texliveFull
    zotero

    easyeffects

    eog
    evince
    gnome-sound-recorder
    gnome-text-editor

    cargo
    tldr
    python3

    yazi

    zed-editor

    opencode
    pkgs-unstable.claude-code
    pkgs-unstable.antigravity-cli
  ];

  environment.shellAliases = {
    ws-name = "niri msg action set-workspace-name";
    ws-clear = "niri msg action unset-workspace-name";
  };

  programs.nix-ld.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # services.thermald.enable = true;

  #services.fprintd.enable = true;

  zramSwap = {
    enable = true;
    memoryPercent = 25;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
}
