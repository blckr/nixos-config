# Fetched, not copied into this public repo: the community collections are MIT,
# but the rights to the individual (recoloured) images are unclear
{ pkgs }:
let
  nordic = path: hash: pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/linuxdotexe/nordic-wallpapers/7a8e3bcabafbefd1c5b19229841b9bf377a4b765/dynamic-wallpapers/${path}";
    inherit hash;
  };
  catppuccin = path: hash: pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/zhichaoh/catppuccin-wallpapers/1023077979591cdeca76aae94e0359da1707a60e/landscapes/${path}";
    inherit hash;
  };
  everforest = path: hash: pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/Apeiros-46B/everforest-walls/8f538b4e34a880748a471dc4c7aade6e29982417/nature/${path}";
    inherit hash;
  };
in
{
  nord = {
    light = nordic "Fuji/ign_Fuji-1.png" "sha256-9XyLJ5M0zoqQ6IR0Igee6ye2lBiTQDv47Y2632GCHV4=";
    dark = nordic "Fuji/ign_Fuji-2.png" "sha256-Bakb2sJJe6LnPzal/XbGCAGvVisjAgSCyMXyDQJsFjk=";
  };
  # No Ayu collection exists; the warm desert fits its orange accents
  ayu = {
    light = nordic "TheDesert/ign_TheDesert-0.jpg" "sha256-kpdpDUTcuR4Yr0dpNiGo9EsaSriaCC9NxI4lfymkJ5A=";
    dark = nordic "TheDesert/ign_TheDesert-1.jpg" "sha256-xsBX/kYuLgsbrp/GPDvdXOsVaBs3JZ3+4fzZLpWp5xU=";
  };
  catppuccin = {
    light = catppuccin "tropic_island_day.jpg" "sha256-Zm3G+c64Lr9jnG4CyhaNgE+W3VIQsODDxwDwvM+E2Qs=";
    dark = catppuccin "tropic_island_night.jpg" "sha256-Fm800h7CbEHqcPDL7oKSBSIpGBhEWLFS6ioV5qM0SVw=";
  };
  everforest = {
    light = everforest "fog_forest_1.png" "sha256-wQxWI0FNc37mvRO4zV123NXG50XOO6qKv7J8IKIxgmo=";
    dark = everforest "mist_forest_1.png" "sha256-tGudS0BU83wbBEDCBrXWk7arkce8Bf0u+fUE3cTBYZ0=";
  };
}
