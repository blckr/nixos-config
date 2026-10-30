# --> Find File Type
# file --mime-type -b document.pdf
# --> Find available Programs
# ls /run/current-system/sw/share/applications/
{ username, ... }:
{
  xdg.terminal-exec = {
    enable = true;
    settings.default = [ "com.mitchellh.ghostty.desktop" ];
  };
}
