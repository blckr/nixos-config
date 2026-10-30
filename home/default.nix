# Platform-neutral home-manager configuration (Linux and Mac).
# Platform-specific parts live in ./linux and ./darwin.
{
  imports = [
    ./apps
    ./programs/btop.nix
    ./programs/ghostty
    ./programs/helix.nix
    ./programs/kit
    ./programs/zellij.nix
  ];
}
