{
  pkgs,
  ...
}:
let

  wifi = pkgs.writeShellScriptBin "wifi" ''
    ghostty -e impala
  '';

  bluetooth = pkgs.writeShellScriptBin "bluetooth" ''
    ghostty -e bluetui
  '';

  audio = pkgs.writeShellScriptBin "audio" ''
    ghostty -e wiremix
  '';

in
{
  environment.systemPackages = [
    wifi
    bluetooth
    audio
  ];
}
