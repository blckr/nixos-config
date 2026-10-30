# BTOP is a modern system monitor
{ ... }:
{

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "nord";
      theme_background = false;
      truecolor = true;
    };
  };

}
