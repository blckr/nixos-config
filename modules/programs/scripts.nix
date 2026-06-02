{ pkgs, ... }:
let
  wifi = pkgs.writeShellScriptBin "wifi" ''
    kitty impala
  '';

  bluetooth = pkgs.writeShellScriptBin "bluetooth" ''
    kitty bluetui
  '';

  audio = pkgs.writeShellScriptBin "audio" ''
    kitty wiremix
  '';

  theme-toggle = pkgs.writeShellScriptBin "theme-toggle" ''
    # Find the host config file
    HOSTNAME=$(hostname)
    CONFIG_FILE="/home/arved/code-blckr/nixos-config/hosts/$HOSTNAME/config.nix"
    
    # Get active theme
    ACTIVE_THEME=$(grep 'theme.active =' "$CONFIG_FILE" | cut -d'"' -f2)
    
    # We need to find the complement. Since we can't easily eval Nix here without a full nix-instantiate,
    # we'll look for the complement line in the nix file.
    THEME_FILE="/home/arved/code-blckr/nixos-config/modules/core/themes/$ACTIVE_THEME.nix"
    COMPLEMENT=$(grep "complement =" "$THEME_FILE" | cut -d'"' -f2)

    if [ -n "$COMPLEMENT" ]; then
        theme-select "$COMPLEMENT"
    else
        notify-send "Theme" "No light/dark complement defined for $ACTIVE_THEME" 2>/dev/null || true
    fi
  '';

  theme-select = pkgs.writeShellScriptBin "theme-select" ''
    CONFIG_DIR="/home/arved/code-blckr/nixos-config"
    THEMES_DIR="$CONFIG_DIR/modules/core/themes"
    HOSTNAME=$(hostname)
    HOST_CONFIG="$CONFIG_DIR/hosts/$HOSTNAME/config.nix"

    THEME=$1
    if [ -z "$THEME" ]; then
      THEME=$(ls "$THEMES_DIR" | grep .nix | grep -v current.nix | sed 's/.nix//' | ${pkgs.fzf}/bin/fzf --prompt="Select Theme: ")
      if [ -z "$THEME" ]; then
        exit 0
      fi
    fi

    if [ ! -f "$THEMES_DIR/$THEME.nix" ]; then
      echo "Theme $THEME not found at $THEMES_DIR/$THEME.nix"
      exit 1
    fi
    THEME_FILE="$THEMES_DIR/$THEME.nix"

    # Update host config with flexible regex
    sed -i "s/[[:space:]]*theme.active = \".*\";/    theme.active = \"$THEME\";/" "$HOST_CONFIG"
    
    echo "Theme set to $THEME in $HOST_CONFIG. Rebuilding system..."
    
    # Get hostname
    HOSTNAME=$(hostname)
    
    # Run rebuild
    cd "$CONFIG_DIR"
    if sudo nixos-rebuild switch --flake .#"$HOSTNAME"; then
        echo "Rebuild successful. Reloading applications..."
        
        # Restart UI services if they exist (prevents errors if uninstalled)
        systemctl --user try-restart swaybg.service waybar.service fnott.service swaync.service dunst.service 2>/dev/null || true

        # Set system-wide color scheme (GSettings/dconf)
        VARIANT=$(grep "variant =" "$THEME_FILE" | cut -d'"' -f2)
        if [ "$VARIANT" = "light" ]; then
            dconf write /org/gnome/desktop/interface/color-scheme "'prefer-light'"
        else
            dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
        fi

        # Live GTK & Icon Reload
        GTK_THEME=$(grep 'name =' "$THEME_FILE" | head -n1 | cut -d'"' -f2)
        ICON_THEME=$(grep 'icons =' "$THEME_FILE" | cut -d'"' -f2)
        if [ -n "$GTK_THEME" ]; then
            dconf write /org/gnome/desktop/interface/gtk-theme "'$GTK_THEME'"
        fi
        if [ -n "$ICON_THEME" ]; then
            dconf write /org/gnome/desktop/interface/icon-theme "'$ICON_THEME'"
        fi

        # Kitty Live Reload
        for socket in /tmp/kitty-*; do
          ${pkgs.kitty}/bin/kitty @ --to "unix:$socket" load-config 2>/dev/null || true
        done

        # Helix Live Reload
        pkill -USR1 -x hx || true

        # Niri Live Reload
        ${pkgs.niri}/bin/niri msg action load-config-file || true

        # Zellij Live Reload
        for session in $(${pkgs.zellij}/bin/zellij list-sessions -s 2>/dev/null); do
            Z_THEME=$(grep 'theme "' "$THEME_FILE" | cut -d'"' -f2)
            ${pkgs.zellij}/bin/zellij -s "$session" action themes "$Z_THEME" 2>/dev/null || true
        done
        
        # Send notification in background to prevent timeout blocking if no daemon is running
        notify-send "Theme" "Switched to $THEME" 2>/dev/null &
    else
        echo "Rebuild failed!"
        exit 1
    fi
  '';

  script-selector = pkgs.writeShellScriptBin "script-selector" ''
    CONFIG_DIR="$HOME/code-blckr/nixos-config"
    THEMES_DIR="$CONFIG_DIR/modules/core/themes"
    SCRIPTS="wifi\nbluetooth\naudio\ntheme-toggle\ntheme-select"

    CHOICE=$(echo -e "$SCRIPTS" | ${pkgs.wofi}/bin/wofi -d -p "Select Script:")
    
    if [ "$CHOICE" == "theme-select" ]; then
        SELECTED_THEME=$(ls "$THEMES_DIR" | grep .nix | grep -v current.nix | sed 's/.nix//' | ${pkgs.wofi}/bin/wofi -d -p "Select Theme:")
        if [ -n "$SELECTED_THEME" ]; then
            exec theme-select "$SELECTED_THEME"
        fi
    elif [ -n "$CHOICE" ]; then
      exec "$CHOICE"
    fi
  '';
in
{
  environment.systemPackages = [
    wifi
    bluetooth
    audio
    theme-toggle
    theme-select
    script-selector
  ];
}
