{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [

    papers
    nautilus
    eog
  ];
}
