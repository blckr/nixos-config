{
  imports = [
    ./kanshi.nix
    ./easyeffects.nix
  ];

  modules = {
    desktop.walker.bitwarden.enable = false;

    apps = {
      firefox.enable = true;
      thunderbird.enable = true;
      vscode.enable = true;
    };
  };
}
