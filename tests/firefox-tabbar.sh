# Checks that Firefox's vertical tab bar matches the dark/light mode for every
# theme. Needs the live desktop session: it switches looks with kit, starts
# Firefox with a throwaway profile in a headless sway, measures the tab bar and
# restores the previous look at the end. Takes about 15 s per look.
work="$(mktemp -d)"
state="${XDG_STATE_HOME:-$HOME/.local/state}/kit"
oldTheme="$(cat "$state/theme" 2>/dev/null || echo "")"
oldMode="$(cat "$state/mode" 2>/dev/null || echo dark)"
failed=0

# shellcheck disable=SC2329 # called via trap
restore() {
  [ -n "$oldTheme" ] && kit theme "$oldTheme" >/dev/null
  kit "$oldMode" >/dev/null
  rm -rf "$work"
}
trap restore EXIT

# Prints the luminance (0-255) of pixel $2 in image $1
luminance() {
  magick "$1" -colorspace Gray -format "%[fx:int(255*p{$2})]" info:
}

shot() {
  local name=$1 prof="$work/profile-$1" sock
  mkdir -p "$prof"
  cat >"$prof/user.js" <<JS
user_pref("sidebar.revamp", true);
user_pref("sidebar.verticalTabs", true);
user_pref("browser.tabs.inTitlebar", 0);
user_pref("browser.aboutwelcome.enabled", false);
user_pref("browser.shell.checkDefaultBrowser", false);
JS
  printf 'output HEADLESS-1 resolution 1000x700\ndefault_border none\n' >"$work/sway.conf"
  WLR_BACKENDS=headless WLR_RENDERER=pixman WLR_LIBINPUT_NO_DEVICES=1 \
    sway -c "$work/sway.conf" >"$work/sway.log" 2>&1 &
  local swayPid=$!
  sleep 2
  sock="$(find "$XDG_RUNTIME_DIR" -maxdepth 1 -name 'wayland-*' -newer "$work/sway.conf" ! -name '*.lock' | head -1)"
  WAYLAND_DISPLAY="$(basename "$sock")" MOZ_ENABLE_WAYLAND=1 \
    firefox --no-remote --new-instance --profile "$prof" about:blank >"$work/firefox.log" 2>&1 &
  local ffPid=$!
  sleep 12
  WAYLAND_DISPLAY="$(basename "$sock")" grim "$work/$name.png"
  kill "$ffPid" "$swayPid" 2>/dev/null || true
  wait "$ffPid" "$swayPid" 2>/dev/null || true
}

for theme in $(kit theme | tr -d '* '); do
  kit theme "$theme" >/dev/null
  for mode in dark light; do
    kit "$mode" >/dev/null
    shot "$theme-$mode"
    bar="$(luminance "$work/$theme-$mode.png" 20,400)"
    if { [ "$mode" = dark ] && [ "$bar" -lt 128 ]; } || { [ "$mode" = light ] && [ "$bar" -ge 128 ]; }; then
      echo "ok      $theme-$mode (Leiste: Helligkeit $bar)"
    else
      echo "FEHLER  $theme-$mode (Leiste: Helligkeit $bar)"
      cp "$work/$theme-$mode.png" "${TMPDIR:-/tmp}/firefox-tabbar-$theme-$mode.png"
      failed=1
    fi
  done
done
exit "$failed"
