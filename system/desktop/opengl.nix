{
  config, pkgs, lib, ...
}:
{
  hardware.graphics.enable = true;

  hardware.graphics.extraPackages = with pkgs; [
    libGL
  ];
}
