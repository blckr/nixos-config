# Einheitliche Keybindings: Linux (niri / GNOME) ↔ Mac (Arbeitslaptop)

> Status: **teilweise umgesetzt** auf Branch `home-manager-split`, Stand 2026-10-30.
> Einträge mit *(prüfen)* sind aus dem Gedächtnis und müssen am Gerät verifiziert werden.

## Umsetzungsstand

| Bereich                               | Stand       | Wo                                               |
| ------------------------------------- | ----------- | ------------------------------------------------ |
| Ordner `home/` getrennt von `system/` | ✓ umgesetzt | `home/`, `system/`, `hosts/*/home.nix`           |
| Mac als `homeConfigurations`          | ✓ umgesetzt | `flake.nix` (`hosts.work-mac`), `lib/homes.nix`  |
| EurKEY überall                        | ✓ umgesetzt | `settings.nix`                                   |
| Hintergrund aus `assets/`, auch GNOME | ✓ umgesetzt | `settings.nix`, `home/linux/gnome.nix`           |
| Ghostty-Bindings (Abschnitt 2)        | ✓ umgesetzt | `home/programs/ghostty/keybinds.nix`             |
| niri/GNOME-Systemkürzel (Abschnitt 4) | ✓ umgesetzt | `home/linux/niri.nix`, `home/linux/gnome.nix`    |
| niri `Mod+Tab` als Fensterwechsler    | offen       | Aktion *(prüfen)*                                |
| niri `Mod+Ctrl+F` Vollbild            | offen       | optional                                         |
| Chrome-Menü-Shortcuts (Abschnitt 3A)  | offen       | Menütitel und Chrome-Sprache klären, nicht raten |
| Mac-Benutzername                      | offen       | `flake.nix`, `hosts.work-mac.username`           |

### Ordnerstruktur

```
flake.nix            eine hosts-Liste; arch = "…-darwin" -> homeConfigurations
settings.nix         gemeinsame Werte: Tastaturlayout, Hintergrund
lib/
  hosts.nix          NixOS-Rechner (home-manager integriert)
  homes.nix          Mac (eigenständiges home-manager)
  keybindings.nix    Übersetzung Mac -> Linux, Kollisionsprüfung
  checks.nix         nix flake check
system/              nur NixOS
home/                home-manager, plattformneutral
  linux/             nur unter NixOS, darf osConfig nutzen
  darwin/            nur Mac
hosts/<rechner>/     config.nix (System), home.nix (home-manager)
assets/wallpapers/   Hintergründe
```

### Befehle

Alles läuft über `kit` (auf Linux und Mac):

| Befehl                            | Linux                                                                | Mac                                  |
| --------------------------------- | -------------------------------------------------------------------- | ------------------------------------ |
| `kit build system`                | System bauen, Diff zum laufenden System                              | – (kein NixOS)                       |
| `kit build home`                  | nur home-manager bauen, Diff                                         | home-manager bauen, Diff             |
| `kit switch system`               | `sudo nixos-rebuild switch`                                          | – (kein NixOS)                       |
| `kit switch home`                 | home-manager aktivieren, ohne sudo                                   | home-manager aktivieren              |
| `kit keys [ghostty/niri/gnome]`   | Keybindings aus den Nix-Daten                                        | nur Ghostty                          |
| `kit light` / `kit dark`          | hell/dunkel umschalten, Theme bleibt                                 | macOS-Erscheinungsbild (`osascript`) |
| `kit theme [nord/ayu/catppuccin]` | Theme wechseln, hell/dunkel bleibt (Specialisation `<theme>-<mode>`) | nur Ghostty-Theme                    |

- `KIT_DRY_RUN=1` zeigt nur die Befehle, `KIT_FLAKE=PFAD` überschreibt den Repo-Pfad.
- Nach `kit switch` werden das zuvor gewählte Theme und der Modus wieder gesetzt.
- Erstinstallation auf dem Mac (vor `kit`): `nix run home-manager/release-26.05 -- switch --flake .#arved@work-mac`
- Themes stehen in `home/themes.nix`, das Standard-Theme in `settings.nix`.
- Tests: `nix flake check` (Keybinding-Übersetzung, Kollisionen, beide Ghostty-Configs, Mac-Config, kit auf Linux und Mac, alle Theme-Varianten)
- Firefox-Leiste je Theme und Modus: `nix run .#firefox-tabbar-test` (schaltet den laufenden Desktop kurz durch alle Varianten)

## Rahmenbedingungen

- Mac ist ein **Arbeitslaptop**: keine invasive Software (kein Karabiner, kein AeroSpace, kein Tiling).
- Auf dem Mac läuft **EurKEY** als Tastaturlayout.
- Mac und GNOME bleiben **Floating-Desktops**, nur niri tilet. Das ist gewollt.
- **Alles muss deklarativ sein.** Was sich nicht aus diesem Repo erzeugen lässt, fliegt raus.
- Größter Nutzen: **Ghostty ↔ Ghostty** und **Chrome ↔ Firefox**.

## Leitprinzipien

1. **Super gehört dem Betriebssystem.** Fenstermanagement, Apps starten und Apps schließen (`Super+Q`) liegen unter Linux auf `Super`, auf dem Mac auf `Cmd`. App-interne Shortcuts (Kopieren, Tabs, Splits) nutzen `Super` nie, damit niri und GNOME die Taste ungestört behalten.
2. **Der Mac ist die Referenz**, denn er ist am unflexibelsten. Linux passt sich an, wo es geht.
3. **Ausnahme Browser:** Firefox lässt eingebaute Shortcuts nicht ändern, Chrome auf dem Mac schon (über Menü-Shortcuts). Dort passt sich also Chrome an Firefox an.
4. **Feste Übersetzung der Modifier**, keine Einzelfälle:

| Mac                     | Linux            | Wo                                                            |
| ----------------------- | ---------------- | ------------------------------------------------------------- |
| `Cmd`                   | `Super`          | Betriebssystem: Fenster, Apps starten/schließen (niri, GNOME) |
| `Cmd`                   | `Ctrl`           | Browser, normale Apps                                         |
| `Cmd`                   | `Ctrl+Shift`     | Ghostty                                                       |
| `Cmd+Shift` / `Cmd+Alt` | `Ctrl+Shift+Alt` | Ghostty (wie früher in kitty `C-S-A-t`)                       |
| `Control`               | `Ctrl`           | im Terminal (helix, Shell): identisch                         |
| linke `Option`          | linke `Alt`      | im Terminal: Alt (helix `A-…`)                                |
| rechte `Option`         | `AltGr`          | Umlaute / Sonderzeichen (EurKEY)                              |

---

## 1. Tastaturlayout: EurKEY überall

**Problem:** Linux nutzt `us` + `altgr-intl` (`AltGr+q` = ä, `AltGr+y` = ü, `AltGr+p` = ö). EurKEY auf dem Mac legt die Umlaute auf die gleichnamigen Buchstaben (`Option+a` = ä, `+o` = ö, `+u` = ü, `+s` = ß). Dadurch landen die Umlaute auf beiden Systemen auf verschiedenen Tasten.

**Lösung:** EurKEY gibt es in xkb als Layout `eu`. Es ersetzt `us`/`altgr-intl` an allen drei Stellen, die heute das Layout setzen:

| Stelle  | Datei                                                   | Heute               | Neu              |
| ------- | ------------------------------------------------------- | ------------------- | ---------------- |
| niri    | `modules/desktop/niri/niri.nix` (`input.keyboard.xkb`)  | `us` / `altgr-intl` | `layout "eu"`    |
| Greeter | `modules/services/greetd.nix` (`keyboard`)              | `us` / `altgr-intl` | `layout = "eu"`  |
| GNOME   | neu: `dconf.settings."org/gnome/desktop/input-sources"` | nicht gesetzt       | `[('xkb','eu')]` |

`caps:none` bleibt überall. Damit es nur **eine** Quelle gibt, sollten die drei Stellen auf eine gemeinsame Option zeigen (z. B. `modules.keyboard.layout`).

**Ghostty auf dem Mac:** `macos-option-as-alt = left`. Die linke Option ist dann im Terminal Alt (wie unter Linux), mit der rechten tippst du Umlaute (wie AltGr). Restunterschied: Außerhalb des Terminals erzeugt auf dem Mac auch die linke Option Umlaute, unter Linux nicht.

---

## 2. Ghostty ↔ Ghostty (Priorität 1)

### Idee

Die Bindings werden **einmal in Mac-Notation** definiert. Nix übersetzt sie für Linux nach der Regel oben:

```
cmd+shift+X, cmd+alt+X  →  ctrl+shift+alt+X
cmd+X                   →  ctrl+shift+X
```

Auf beiden Systemen steht `keybind = clear` am Anfang, danach die vollständige Liste. So sind beide **per Konstruktion** gleich, ohne versteckte Plattform-Defaults.

### Ergebnis

| Aktion                        | Mac (Referenz)          | Linux heute                    | Linux neu                                                     |
| ----------------------------- | ----------------------- | ------------------------------ | ------------------------------------------------------------- |
| Kopieren / Einfügen           | `Cmd+C` / `Cmd+V`       | `C-S-c` / `C-S-v`              | gleich ✓                                                      |
| Neuer Tab                     | `Cmd+T`                 | `C-S-t`                        | gleich ✓                                                      |
| Neues Fenster                 | `Cmd+N`                 | `C-S-n`                        | gleich ✓                                                      |
| Split / Tab schließen         | `Cmd+W`                 | `C-S-w` (schließt den **Tab**) | `C-S-w` → `close_surface`                                     |
| Fenster schließen             | `Cmd+Shift+W`           | `Alt+F4`                       | `C-S-A-w`                                                     |
| App beenden                   | `Cmd+Q`                 | `C-S-q`                        | **`Super+Q`** (OS-Ebene, siehe Abschnitt 4), `C-S-q` entfällt |
| **Split rechts**              | `Cmd+D`                 | `C-S-o`                        | **`C-S-d`**                                                   |
| **Split unten**               | `Cmd+Shift+D`           | `C-S-e`                        | **`C-S-A-d`**                                                 |
| Split vor / zurück            | `Cmd+[` / `Cmd+]`       | `Super+C-[` / `]`              | `C-S-[` / `]`                                                 |
| Split per Richtung            | `Cmd+Alt+Pfeile`        | `C-Alt-Pfeile`                 | `C-S-A-Pfeile`                                                |
| Split-Zoom                    | `Cmd+Shift+Enter`       | `C-S-Enter`                    | `C-S-A-Enter`                                                 |
| **Tab vor / zurück**          | `Cmd+Shift+]` / `[`     | `C-PgDn` / `C-PgUp`            | **`C-S-A-]` / `[`**                                           |
| Tab vor / zurück (universell) | `Ctrl+Tab`              | `Ctrl+Tab`                     | ✓ überall gleich, auch in beiden Browsern                     |
| Tab 1–8 / letzter             | `Cmd+1…8` / `Cmd+9`     | `Alt+1…8` / `Alt+9`            | **bleibt `Alt`**, siehe Ausnahmen                             |
| Suchen                        | `Cmd+F`                 | `C-S-f`                        | gleich ✓                                                      |
| Command Palette               | `Cmd+Shift+P`           | `C-S-p`                        | `C-S-A-p`                                                     |
| Zum Prompt springen           | `Cmd+↑` / `Cmd+↓`       | `C-S-PgUp/PgDn`                | `C-S-↑` / `C-S-↓`                                             |
| Vollbild                      | `Cmd+Ctrl+F`            | `C-Enter`                      | niri/GNOME regeln das, siehe Abschnitt 4                      |
| Config öffnen / neu laden     | `Cmd+,` / `Cmd+Shift+,` | `C-,` / `C-S-,`                | `C-S-,` / `C-S-A-,`                                           |

**Bewusste Ausnahmen:**
- **Schriftgröße** bleibt unter Linux `Ctrl+=` / `Ctrl+-` / `Ctrl+0`, wie im Browser.
- **Tab N** bleibt unter Linux `Alt+N`, wie in Firefox unter Linux. Auf der MacBook-Tastatur liegt `Cmd` genau dort, wo am PC `Alt` liegt, es ist also derselbe Daumen.

### Skizze

```nix
let
  # Quelle der Wahrheit: Mac-Notation
  binds = {
    "cmd+c" = "copy_to_clipboard";
    "cmd+v" = "paste_from_clipboard";
    "cmd+t" = "new_tab";
    "cmd+n" = "new_window";
    "cmd+w" = "close_surface";
    "cmd+shift+w" = "close_window";
    "cmd+q" = "quit";
    "cmd+d" = "new_split:right";
    "cmd+shift+d" = "new_split:down";
    "cmd+bracket_left" = "goto_split:previous";
    "cmd+bracket_right" = "goto_split:next";
    "cmd+shift+bracket_left" = "previous_tab";
    "cmd+shift+bracket_right" = "next_tab";
    "cmd+alt+arrow_left" = "goto_split:left";
    # … restliche Zeilen aus der Tabelle
  };
  toLinux = lib.replaceStrings
    [ "cmd+shift+" "cmd+alt+" "cmd+" ]
    [ "ctrl+shift+alt+" "ctrl+shift+alt+" "ctrl+shift+" ];
  linuxBinds = lib.mapAttrs' (k: v: lib.nameValuePair (toLinux k) v) binds;
in
assert lib.length (lib.attrNames linuxBinds) == lib.length (lib.attrNames binds); # keine Kollision
{ /* keybind = [ "clear" ] ++ … */ }
```

### Offene Punkte

- Unter **GNOME** belegen `Ctrl+Alt+←/→` (Workspace wechseln) und `Ctrl+Shift+Alt+←/→` (Fenster verschieben) dieselben Tasten. Die müssen dort per dconf abgeschaltet werden, siehe Abschnitt 4.
- Tastennamen wie `bracket_left` mit Shift *(prüfen)* mit `ghostty +list-keybinds`.

---

## 3. Chrome (Mac) ↔ Firefox (Linux) (Priorität 1)

### Was schon gleich ist (Ctrl ↔ Cmd)

Neuer Tab `t`, geschlossenen Tab wiederherstellen `Shift+T`, schließen `w`, Fenster schließen `Shift+W`, Adresszeile `l`, Suchen `f` / `g`, Neu laden `r` / `Shift+R`, Zoom `=` `-` `0`, Lesezeichen setzen `d`, Lesezeichenleiste `Shift+B`, `Ctrl+Tab`, Tab N (siehe Ghostty). Beenden ist OS-Ebene: `Cmd+Q` ↔ `Super+Q`.

### Was abweicht

| Aktion                    | Firefox (Linux)                | Chrome (Mac)                |
| ------------------------- | ------------------------------ | --------------------------- |
| **Lesezeichen-Manager**   | `C-S-o`                        | `Cmd+Alt+B`                 |
| Lesezeichen-Seitenleiste  | `C-b`                          | –                           |
| Verlauf                   | `C-h` (Seitenleiste) / `C-S-h` | `Cmd+Y`                     |
| Downloads                 | `C-S-y`                        | `Cmd+Shift+J`               |
| Privates Fenster          | `C-S-p`                        | `Cmd+Shift+N`               |
| DevTools                  | `C-S-i`                        | `Cmd+Alt+I`                 |
| Konsole                   | `C-S-k`                        | `Cmd+Alt+J`                 |
| Zurück / Vor              | `Alt+←/→`                      | `Cmd+[` / `Cmd+]`           |
| Nächster Tab (alternativ) | `C-PgDn`                       | `Cmd+Alt+→` / `Cmd+Shift+]` |
| Vollbild                  | `F11`                          | `Cmd+Ctrl+F`                |

### Hebel

| Option                                                                                                               | Deklarativ?                              | Aufwand | Bewertung                                                      |
| -------------------------------------------------------------------------------------------------------------------- | ---------------------------------------- | ------- | -------------------------------------------------------------- |
| **A. Chrome-Menü-Shortcuts auf Firefox-Belegung umbiegen** (`defaults write com.google.Chrome NSUserKeyEquivalents`) | ✓                                        | gering  | **Empfehlung.** Gilt aber nur für Aktionen, die im Menü stehen |
| B. Firefox auch auf dem Mac                                                                                          | ✓ (`user.js`, policies)                  | gering  | am besten, falls erlaubt *(IT fragen)*                         |
| C. Gleiche Extension in beiden (z. B. Vimium)                                                                        | ✗ Settings nur per manuellem JSON-Import | mittel  | eher nicht, wegen der Anforderung „deklarativ“                 |

**Zu A, Beispiele.** Menütitel *(prüfen)*, sie hängen von der Chrome-Sprache ab:

```
defaults write com.google.Chrome NSUserKeyEquivalents -dict-add \
  "Lesezeichen-Manager" "@\$o"   # Cmd+Shift+O wie Firefox
  "Downloads"           "@\$y"   # Cmd+Shift+Y
  "Verlauf anzeigen"    "@\$h"   # Cmd+Shift+H
  "Neues Inkognitofenster" "@\$p"
  "Entwicklertools"     "@\$i"
# @ = Cmd, $ = Shift, ~ = Option, ^ = Control
```

**Gegen das Raten:** Die Titel werden einmal exakt aus der Menüleiste abgeschrieben, und die Chrome-Sprache wird fixiert. Nach dem Anwenden steht der neue Shortcut sichtbar im Menü. Ob es geklappt hat, ist also sofort zu sehen.

---

## 4. Systemebene: niri & GNOME an den Mac angleichen

| Aktion                  | Mac (fix)         | niri heute                  | niri neu                                             | GNOME neu (dconf)                                      |
| ----------------------- | ----------------- | --------------------------- | ---------------------------------------------------- | ------------------------------------------------------ |
| Launcher                | `Cmd+Space`       | `Mod+Space` ✓               | –                                                    | `Super+Space` → Übersicht (Eingabequellen-Wechsel aus) |
| App/Fenster schließen   | `Cmd+Q` / `Cmd+W` | `Mod+X`                     | **`Mod+Q`**                                          | **`Super+Q`** (+ `Alt+F4`)                             |
| App-Wechsler            | `Cmd+Tab`         | `Mod+Tab` = vorh. Workspace | niri-Fensterwechsler auf `Mod+Tab` *(Aktion prüfen)* | `Super+Tab` ✓ Default                                  |
| Fenster derselben App   | ``Cmd+` ``        | –                           | –                                                    | ``Super+` `` ✓ Default                                 |
| Sperren                 | `Ctrl+Cmd+Q`      | `Mod+Shift+L`               | **`Mod+Ctrl+Q`**                                     | **`Super+Ctrl+Q`** (statt `Super+L`)                   |
| Screenshot Bildschirm   | `Cmd+Shift+3`     | –                           | `Mod+Shift+3`                                        | `Super+Shift+3`                                        |
| Screenshot Bereich      | `Cmd+Shift+4`     | `Mod+Shift+P`               | `Mod+Shift+4`                                        | `Super+Shift+4`                                        |
| Screenshot-UI           | `Cmd+Shift+5`     | –                           | `Mod+Shift+5`                                        | `Super+Shift+5`                                        |
| Minimieren / Ausblenden | `Cmd+M` / `Cmd+H` | – (H = Fokus)               | bleibt Fokus                                         | `Super+M`, `Super+H` (Default)                         |
| Vollbild                | `Cmd+Ctrl+F`      | `Mod+Shift+F`               | `Mod+Ctrl+F` *(optional; heute expand-column)*       | `Super+Ctrl+F`                                         |
| Beamer-Modus            | –                 | –                           | –                                                    | `Super+P` ✓ Default, nicht anfassen                    |

Alte niri-Bindings bleiben vorübergehend als Alias und fliegen nach der Eingewöhnung raus.

**GNOME zusätzlich:**
- `switch-to-workspace-left/right` und `move-to-workspace-left/right` ohne `Ctrl+Alt`-Varianten, sonst kollidieren sie mit Ghostty (Abschnitt 2).
- `Super+L` (sperren) freimachen, damit die niri-Gewohnheit keinen Schaden anrichtet.

Nicht angeglichen (bewusst): Spaces/Workspaces, Tiling, Overview / Mission Control.

---

## 5. helix

Die Config ist auf beiden Systemen gleich. `Ctrl` ist überall die echte Control-Taste.

- Für die `A-…`-Bindings braucht es `macos-option-as-alt = left` (Abschnitt 1).
- `space t = ":sh setsid -f ghostty"` wird auf dem Mac zu `open -na Ghostty`.
- Die Zwischenablage erkennt helix selbst (wl-copy / pbcopy).
- Offen: Wie kommt helix auf den Mac? *(IT / brew?)*

---

## 6. Deklarativ auf dem Mac: geht das?

**Ja, für fast alles, was hier relevant ist**, und zwar mit Bordmitteln:

| Was                                                      | Mechanismus                                           | ohne Nix?                                     |
| -------------------------------------------------------- | ----------------------------------------------------- | --------------------------------------------- |
| Ghostty, helix                                           | Textdateien in `~/.config/`                           | ✓                                             |
| Menü-Shortcuts einzelner Apps (Chrome, Ghostty, Finder)  | `defaults write <bundle-id> NSUserKeyEquivalents`     | ✓                                             |
| System-Shortcuts (Spotlight, Screenshots, Eingabequelle) | `defaults write com.apple.symbolichotkeys`            | ✓, aber numerische IDs und Neuanmeldung nötig |
| Text-Editing-Tasten in Cocoa-Apps                        | `~/Library/KeyBindings/DefaultKeyBinding.dict`        | ✓                                             |
| Tastaturlayout EurKEY                                    | `~/Library/Keyboard Layouts/` + `com.apple.HIToolbox` | ✓                                             |
| Chrome-Shortcuts ohne Menüeintrag                        | –                                                     | ✗ nicht möglich                               |

Achtung: MDM-Profile der IT können einzelne `defaults` überschreiben.

### Ausrollen

Nix + home-manager auf dem Mac: `homeConfigurations."arved@work-mac"` aus diesem Repo, `programs.ghostty.package = pkgs.ghostty-bin`. Dafür muss Nix auf dem Mac installiert sein (root, `/nix`-Volume, Daemon) → mit der **IT** klären.

---

## 7. Wie testen wir das?

- **Ghostty:** Die Übersetzung prüft sich selbst (`assert` gegen Kollisionen, läuft in `nix flake check`). Auf beiden Systemen `ghostty +validate-config`. Dann `ghostty +list-keybinds` vom Mac durch `toLinux` (bzw. sed) schicken und mit der Linux-Ausgabe vergleichen (`diff`). Erlaubt sind nur die dokumentierten Ausnahmen.
- **niri:** `niri validate`, `nixos-rebuild build`.
- **GNOME:** `dconf dump /org/gnome/` vorher und nachher vergleichen (`diff`). Zusätzlich zeigt *Einstellungen → Tastatur* doppelt belegte Tasten an.
- **Layout:** `niri msg keyboard-layouts` muss `eu` zeigen. Tipp-Test `ä ö ü ß €` auf Linux, GNOME, im Greeter und auf dem Mac.
- **Mac:** `nix flake check` wertet die Mac-Config unter Linux aus und validiert ihre Ghostty-Config. Auf dem Mac danach `home-manager switch` und ein Blick in die Chrome-Menüs: Neue Shortcuts stehen neben dem Eintrag.

---

## Offene Fragen

1. **„Bookmark-Menü, nicht raten“:** Meinst du, dass die Lesezeichen-Shortcuts in Chrome und Firefox gleich sein sollen (→ Abschnitt 3A)? Oder geht es um etwas anderes?
2. Ist **Chrome Pflicht** auf dem Mac, oder ginge Firefox (→ 3B, die einfachste Lösung)?
3. Darf **Nix** auf den Mac?
4. In welcher **Sprache** läuft Chrome auf dem Mac? Die Menütitel hängen davon ab.
5. Wie kommen **Ghostty und helix** auf den Mac (IT, brew, Self-Service)?
6. Soll das alte `Mod+X` / `Mod+Shift+L` in niri als Alias bleiben, und wie lange?

## Nicht-Ziele

- Kein Tiling auf Mac oder GNOME (kein AeroSpace, kein PaperWM).
- Keine Key-Remapper (Karabiner, keyd, xremap).
- `Super` für App-Shortcuts verwenden (Kopieren, Tabs, Splits). `Super` bleibt Betriebssystem-Ebene.
- Die physische Position von `Cmd` und `Super` angleichen: Der Unterschied ist okay.
