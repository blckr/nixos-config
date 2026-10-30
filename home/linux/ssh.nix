{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
  };
  home.file.".ssh/config".enable = false;
}
