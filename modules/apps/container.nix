{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.modules.apps.container;
in
{
  options.modules.apps.container = {
    enable = lib.mkEnableOption "container";
  };

  config = lib.mkIf cfg.enable {
    containers.playground1 = {
      autoStart = false;
      privateNetwork = true;

      config =
        { pkgs, lib, ... }:
        {
          system.stateVersion = "25.11";

          environment.systemPackages = with pkgs; [
            helix
            btop
          ];
        };
    };
  };
}
