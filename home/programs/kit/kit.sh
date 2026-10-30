# kit: tool for this configuration. Nix fills in the @…@ placeholders at build time.
platform="@platform@" # linux | darwin
host="@host@"
user="@user@"
flake="${KIT_FLAKE:-@flake@}"
keys="@keys@"
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
kit – Werkzeug für die Nix-Konfiguration ($flake)

  kit build system|home     bauen und Unterschiede zum laufenden Stand zeigen
  kit switch system|home    bauen und aktivieren
  kit keys [NAME]           Keybindings anzeigen ($(keyNames))
  kit light | dark          helles bzw. dunkles Erscheinungsbild
  kit help                  diese Hilfe

KIT_FLAKE=PFAD überschreibt den Pfad zum Repo, KIT_DRY_RUN=1 zeigt nur die Befehle.
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
  [ "$platform" = linux ] || die "'$1' gibt es nur unter NixOS; auf dem Mac: kit $2 home"
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
  # Activating brings back the dark base, so re-apply light mode
  if [ "$platform" = linux ] && [ "$(cat "$kitState/mode" 2>/dev/null)" = light ]; then
    appearance light
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
  [ -f "$kitState/base" ] || die "keine home-manager-Generation gefunden, zuerst 'kit switch home'"
  cat "$kitState/base"
}

appearance() {
  if [ "$platform" = darwin ]; then
    local darkMode=true
    [ "$1" = light ] && darkMode=false
    run osascript -e "tell application \"System Events\" to tell appearance preferences to set dark mode to $darkMode"
    return
  fi
  local base
  base="$(baseGeneration)"
  if [ "$1" = light ]; then
    run "$base/specialisation/light/activate"
  else
    run "$base/activate"
  fi
  [ -n "$dry" ] || echo "$1" >"$kitState/mode"
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
    die "keine Keybindings für '$1'; vorhanden: $(keyNames)"
  fi
}

case "${1:-help}" in
  build) build "${2:-}" ;;
  switch) switch "${2:-}" ;;
  keys) showKeys "${2:-}" ;;
  light | dark) appearance "$1" ;;
  help | -h | --help) usage ;;
  *)
    usage >&2
    exit 1
    ;;
esac
