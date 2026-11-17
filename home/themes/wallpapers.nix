# Generated from the theme palettes; replace the files to use other pictures
let
  pair = name: {
    light = ../../assets/wallpapers/${name}-light.png;
    dark = ../../assets/wallpapers/${name}-dark.png;
  };
in
{
  nord = pair "nord";
  ayu = pair "ayu";
  catppuccin = pair "catppuccin";
  everforest = pair "everforest";
}
