{
  hostname,
  ...
}:
{
  imports = [
    ./system
  ];

  networking.hostName = hostname;

  system.stateVersion = "25.05";
}

