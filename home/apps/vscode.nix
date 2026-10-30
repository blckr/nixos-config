{ config, lib, ... }:
{
  options.modules.apps.vscode.enable = lib.mkEnableOption "vscode";

  config = lib.mkIf config.modules.apps.vscode.enable {
    programs.vscode.enable = true;
  };
}
