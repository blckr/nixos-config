# Many other apps
{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [

    papers # evince but modern
    nautilus # File Manager
    eog # Show Photos
  ];
}
