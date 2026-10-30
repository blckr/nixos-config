# Plattformneutrale home-manager-Konfiguration (Linux und Mac).
# Plattformspezifisches liegt in ./linux bzw. ./darwin.
{
  imports = [
    ./apps
    ./programs/btop.nix
    ./programs/ghostty.nix
    ./programs/helix.nix
    ./programs/zellij.nix
  ];
}
