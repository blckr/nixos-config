{
  pkgs,
  ...
}:
let

  wifi = pkgs.writeShellScriptBin "wifi" ''
    kitty impala
  '';

  bluetooth = pkgs.writeShellScriptBin "bluetooth" ''
    kitty bluetui
  '';

  audio = pkgs.writeShellScriptBin "audio" ''
    kitty wiremix
  '';

in
{
  environment.systemPackages = [
    wifi
    bluetooth
    audio
  ];
}
