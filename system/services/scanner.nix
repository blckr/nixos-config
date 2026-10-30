{ config, lib, pkgs, inputs, ... }:
{
  hardware.sane.enable = true;

  hardware.sane.brscan5.enable = true;
  users.groups.scanner = {};
}
