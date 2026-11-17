# Everforest Medium from helix's palettes. Ghostty only ships Dark Hard and Light Med,
# so its themes use Ghostty's 16 colours with helix backgrounds.
let
  ansi = {
    dark = [
      "#7a8478"
      "#e67e80"
      "#a7c080"
      "#dbbc7f"
      "#7fbbb3"
      "#d699b6"
      "#83c092"
      "#f2efdf"
      "#a6b0a0"
      "#f85552"
      "#8da101"
      "#dfa000"
      "#3a94c5"
      "#df69ba"
      "#35a77c"
      "#fffbef"
    ];
    light = [
      "#7a8478"
      "#e67e80"
      "#9ab373"
      "#c1a266"
      "#7fbbb3"
      "#d699b6"
      "#83c092"
      "#b2af9f"
      "#a6b0a0"
      "#f85552"
      "#8da101"
      "#dfa000"
      "#3a94c5"
      "#df69ba"
      "#35a77c"
      "#fffbef"
    ];
  };
  names = [
    "black"
    "red"
    "green"
    "yellow"
    "blue"
    "magenta"
    "cyan"
    "white"
  ];
  pick = list: offset: builtins.listToAttrs (
    builtins.genList (i: {
      name = builtins.elemAt names i;
      value = builtins.elemAt list (i + offset);
    }) 8
  );

  # helix palette (bg0, bg1, bg3, bg_visual, fg, accents, greys)
  helix = {
    dark = {
      bg0 = "#2d353b";
      bg1 = "#343f44";
      bg3 = "#475258";
      visual = "#543a48";
      fg = "#d3c6aa";
      red = "#e67e80";
      orange = "#e69875";
      green = "#a7c080";
      aqua = "#83c092";
      blue = "#7fbbb3";
      grey0 = "#7a8478";
      grey2 = "#9da9a0";
      shadow = "#000000";
    };
    light = {
      bg0 = "#fdf6e3";
      bg1 = "#f4f0d9";
      bg3 = "#e6e2cc";
      visual = "#eaedc8";
      fg = "#5c6a72";
      red = "#f85552";
      orange = "#f57d26";
      green = "#8da101";
      aqua = "#35a77c";
      blue = "#3a94c5";
      grey0 = "#a6b0a0";
      grey2 = "#829181";
      shadow = "#fdf6e3";
    };
  };

  ghosttyTheme = mode: let c = helix.${mode}; in {
    palette = builtins.genList (i: "${toString i}=${builtins.elemAt ansi.${mode} i}") 16;
    background = c.bg0;
    foreground = c.fg;
    cursor-color = c.orange;
    cursor-text = c.bg0;
    selection-background = c.visual;
    selection-foreground = c.fg;
  };

  # Same role mapping as the built-in Ayu palette of noctalia
  noctalia = mode: let c = helix.${mode}; in {
    mPrimary = c.green;
    mOnPrimary = c.bg0;
    mSecondary = c.blue;
    mOnSecondary = c.bg0;
    mTertiary = c.aqua;
    mOnTertiary = c.bg0;
    mError = c.red;
    mOnError = c.bg0;
    mSurface = c.bg0;
    mOnSurface = c.fg;
    mSurfaceVariant = c.bg1;
    mOnSurfaceVariant = c.grey2;
    mOutline = c.grey0;
    mShadow = c.shadow;
    mHover = c.aqua;
    mOnHover = c.bg0;
    terminal = {
      background = c.bg0;
      foreground = c.fg;
      cursor = c.orange;
      cursorText = c.bg0;
      selectionBg = c.visual;
      selectionFg = c.fg;
      normal = pick ansi.${mode} 0;
      bright = pick ansi.${mode} 8;
    };
  };

  walker = mode: let c = helix.${mode}; in {
    bg = c.bg0;
    fg = c.fg;
    accent = c.green;
    selection = c.visual;
    border = c.bg3;
  };
in
{
  ghosttyThemes = {
    # No spaces: home-manager validates theme files with an unquoted path
    "everforest-dark-medium" = ghosttyTheme "dark";
    "everforest-light-medium" = ghosttyTheme "light";
  };
  noctaliaPalette = {
    dark = noctalia "dark";
    light = noctalia "light";
  };
  walker = {
    dark = walker "dark";
    light = walker "light";
  };
}
