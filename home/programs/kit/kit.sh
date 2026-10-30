# kit: tool for this configuration. Nix fills in the @…@ placeholders at build time.
platform="@platform@" # linux | darwin
host="@host@"
user="@user@"
flake="${KIT_FLAKE:-@flake@}"
keys="@keys@"
baseTheme="@theme@"
themes="@themes@"
dry="${KIT_DRY_RUN:-}"
state="${XDG_STATE_HOME:-$HOME/.local/state}"
kitState="$state/kit"
currentHome="$state/home-manager/gcroots/current-home"

keyNames() {
  for f in "$keys"/*.txt; do
    printf '%s ' "$(basename "$f" .txt)"
  done
}

usage() {
  cat <<USAGE
kit – tool for the Nix configuration ($flake)

  kit build system|home     build and show the difference to the running state
  kit switch system|home    build and activate
  kit keys [NAME]           show keybindings ($(keyNames))
  kit light | dark          light or dark appearance
  kit theme [NAME]          switch or list colour themes ($themes)
  kit help                  this help

KIT_FLAKE=PATH overrides the repo path, KIT_DRY_RUN=1 only prints the commands.
USAGE
}

die() {
  echo "kit: $*" >&2
  exit 1
}

run() {
  if [ -n "$dry" ]; then
    echo "$*"
  else
    "$@"
  fi
}

needLinux() {
  [ "$platform" = linux ] || die "'$1' only exists on NixOS; on the Mac use: kit $2 home"
}

installable() {
  case "$1" in
    system) echo "$flake#nixosConfigurations.$host.config.system.build.toplevel" ;;
    home)
      if [ "$platform" = linux ]; then
        echo "$flake#nixosConfigurations.$host.config.home-manager.users.$user.home.activationPackage"
      else
        echo "$flake#homeConfigurations.\"$user@$host\".activationPackage"
      fi
      ;;
  esac
}

# Builds and prints the store path (in a dry run only the command, on stderr)
buildPath() {
  if [ -n "$dry" ]; then
    echo "nix build --no-link --print-out-paths $(installable "$1")" >&2
    echo "<out>"
  else
    nix build --no-link --print-out-paths "$(installable "$1")"
  fi
}

current() {
  case "$1" in
    system) echo /run/current-system ;;
    home) readlink -f "$currentHome" 2>/dev/null || true ;;
  esac
}

showDiff() {
  local cur
  cur="$(current "$1")"
  if [ -n "$cur" ]; then
    run nix store diff-closures "$cur" "$2"
  fi
}

build() {
  case "${1:-}" in
    system) needLinux "build system" build ;;
    home) ;;
    *) die "kit build system|home" ;;
  esac
  local out
  out="$(buildPath "$1")"
  showDiff "$1" "$out"
}

switch() {
  case "${1:-}" in
    system)
      needLinux "switch system" switch
      run sudo nixos-rebuild switch --flake "$flake#$host"
      ;;
    home)
      local out
      out="$(buildPath home)"
      showDiff home "$out"
      run "$out/activate"
      ;;
    *) die "kit switch system|home" ;;
  esac
  # Activating brings back the base look, so re-apply the chosen one
  if [ "$(specFor "$(stateOr theme "$baseTheme")" "$(stateOr mode dark)")" != "$(specFor "$baseTheme" dark)" ]; then
    look "$(stateOr theme "$baseTheme")" "$(stateOr mode dark)"
  fi
}

# Linux: the generation with specialisation/ is the base. It is remembered,
# because after `kit light` the light generation is the current one
baseGeneration() {
  local cur
  cur="$(current home)"
  mkdir -p "$kitState"
  if [ -n "$cur" ] && [ -d "$cur/specialisation" ]; then
    echo "$cur" >"$kitState/base"
  fi
  [ -f "$kitState/base" ] || die "no home-manager generation found, run 'kit switch home' first"
  cat "$kitState/base"
}

stateOr() {
  cat "$kitState/$1" 2>/dev/null || echo "$2"
}

# Specialisation name: "<theme>-<mode>" on Linux, "<theme>" on the Mac
# (where only Ghostty is themed and the mode is the macOS appearance)
specFor() {
  if [ "$platform" = linux ]; then
    echo "$1-$2"
  else
    echo "$1"
  fi
}

# Activates theme $1 in mode $2 and remembers both
look() {
  local base spec
  base="$(baseGeneration)"
  spec="$(specFor "$1" "$2")"
  if [ "$spec" = "$(specFor "$baseTheme" dark)" ]; then
    run "$base/activate"
  elif [ -d "$base/specialisation/$spec" ]; then
    run "$base/specialisation/$spec/activate"
  else
    die "no variant '$spec' in $base"
  fi
  if [ -z "$dry" ]; then
    echo "$1" >"$kitState/theme"
    echo "$2" >"$kitState/mode"
  fi
}

mode() {
  if [ "$platform" = darwin ]; then
    local darkMode=true
    [ "$1" = light ] && darkMode=false
    run osascript -e "tell application \"System Events\" to tell appearance preferences to set dark mode to $darkMode"
    return
  fi
  look "$(stateOr theme "$baseTheme")" "$1"
}

theme() {
  local current t
  current="$(stateOr theme "$baseTheme")"
  if [ -z "${1:-}" ]; then
    for t in $themes; do
      if [ "$t" = "$current" ]; then echo "* $t"; else echo "  $t"; fi
    done
    return
  fi
  case " $themes " in
    *" $1 "*) look "$1" "$(stateOr mode dark)" ;;
    *) die "unknown theme '$1'; available: $themes" ;;
  esac
}

showKeys() {
  if [ -z "${1:-}" ]; then
    for f in "$keys"/*.txt; do
      echo "== $(basename "$f" .txt)"
      cat "$f"
      echo
    done
  elif [ -f "$keys/$1.txt" ]; then
    cat "$keys/$1.txt"
  else
    die "no keybindings for '$1'; available: $(keyNames)"
  fi
}

case "${1:-help}" in
  build) build "${2:-}" ;;
  switch) switch "${2:-}" ;;
  keys) showKeys "${2:-}" ;;
  light | dark) mode "$1" ;;
  theme) theme "${2:-}" ;;
  help | -h | --help) usage ;;
  *)
    usage >&2
    exit 1
    ;;
esac
