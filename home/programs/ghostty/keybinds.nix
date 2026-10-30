# Ghostty-Keybindings für Mac und Linux, Übersicht in docs/keybindings.md
{
  # Mac-Notation, wird für Linux übersetzt (cmd -> ctrl+shift, cmd+shift/alt -> ctrl+shift+alt)
  shared = {
    "cmd+c" = "copy_to_clipboard";
    "cmd+v" = "paste_from_clipboard";
    "cmd+a" = "select_all";

    "cmd+n" = "new_window";
    "cmd+t" = "new_tab";
    "cmd+w" = "close_surface";
    "cmd+shift+w" = "close_window";

    "cmd+d" = "new_split:right";
    "cmd+shift+d" = "new_split:down";
    "cmd+bracket_left" = "goto_split:previous";
    "cmd+bracket_right" = "goto_split:next";
    "cmd+alt+arrow_left" = "goto_split:left";
    "cmd+alt+arrow_right" = "goto_split:right";
    "cmd+alt+arrow_up" = "goto_split:up";
    "cmd+alt+arrow_down" = "goto_split:down";
    "cmd+shift+enter" = "toggle_split_zoom";

    "cmd+shift+bracket_left" = "previous_tab";
    "cmd+shift+bracket_right" = "next_tab";

    "cmd+f" = "start_search";
    "cmd+shift+p" = "toggle_command_palette";
    "cmd+arrow_up" = "jump_to_prompt:-1";
    "cmd+arrow_down" = "jump_to_prompt:1";

    "cmd+comma" = "open_config";
    "cmd+shift+comma" = "reload_config";
    "cmd+alt+i" = "inspector:toggle";
  };

  # Auf beiden Systemen gleich, ohne Übersetzung
  common = {
    "ctrl+tab" = "next_tab";
    "ctrl+shift+tab" = "previous_tab";
    "escape" = "end_search";
    "shift+arrow_left" = "adjust_selection:left";
    "shift+arrow_right" = "adjust_selection:right";
    "shift+arrow_up" = "adjust_selection:up";
    "shift+arrow_down" = "adjust_selection:down";
  };

  darwin = {
    "cmd+q" = "quit";
    "cmd+ctrl+f" = "toggle_fullscreen";
    "cmd+equal" = "increase_font_size:1";
    "cmd+minus" = "decrease_font_size:1";
    "cmd+digit_0" = "reset_font_size";
    "cmd+home" = "scroll_to_top";
    "cmd+end" = "scroll_to_bottom";
    "cmd+page_up" = "scroll_page_up";
    "cmd+page_down" = "scroll_page_down";
    # Zeilennavigation wie in macOS-Textfeldern
    "cmd+arrow_left" = "text:\\x01";
    "cmd+arrow_right" = "text:\\x05";
    "cmd+backspace" = "text:\\x15";
    "cmd+digit_1" = "goto_tab:1";
    "cmd+digit_2" = "goto_tab:2";
    "cmd+digit_3" = "goto_tab:3";
    "cmd+digit_4" = "goto_tab:4";
    "cmd+digit_5" = "goto_tab:5";
    "cmd+digit_6" = "goto_tab:6";
    "cmd+digit_7" = "goto_tab:7";
    "cmd+digit_8" = "goto_tab:8";
    "cmd+digit_9" = "last_tab";
  };

  # App beenden übernimmt Super+Q (niri/GNOME), Vollbild der Fenstermanager
  linux = {
    "ctrl+equal" = "increase_font_size:1";
    "ctrl+plus" = "increase_font_size:1";
    "ctrl+minus" = "decrease_font_size:1";
    "ctrl+digit_0" = "reset_font_size";
    "shift+home" = "scroll_to_top";
    "shift+end" = "scroll_to_bottom";
    "shift+page_up" = "scroll_page_up";
    "shift+page_down" = "scroll_page_down";
    "ctrl+insert" = "copy_to_clipboard";
    "shift+insert" = "paste_from_selection";
    # Tab N wie in Firefox unter Linux (Alt liegt dort, wo am Mac Cmd liegt)
    "alt+digit_1" = "goto_tab:1";
    "alt+digit_2" = "goto_tab:2";
    "alt+digit_3" = "goto_tab:3";
    "alt+digit_4" = "goto_tab:4";
    "alt+digit_5" = "goto_tab:5";
    "alt+digit_6" = "goto_tab:6";
    "alt+digit_7" = "goto_tab:7";
    "alt+digit_8" = "goto_tab:8";
    "alt+digit_9" = "last_tab";
  };
}
