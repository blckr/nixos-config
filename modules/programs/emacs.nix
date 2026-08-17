# Emacs – minimale, wachstumsfähige Config (Vanilla-Keybindings), deklarativ via Nix.
#
# Bewusst klein: nur Emacs + ein paar sinnvolle eingebaute Defaults. Wächst
# Schritt für Schritt. Pakete kommen aus Nix (extraPackages), kein package.el.
# GUI via pgtk (Wayland/niri) + funktioniert auch mit `emacs -nw`.
{ username, pkgs, ... }:

let
  emacsPkg = pkgs.emacs-pgtk;

  initEl = ''
    ;;; init.el --- Minimale Emacs-Config zum Lernen -*- lexical-binding: t; -*-
    ;; Bewusst klein gehalten. Wächst Schritt für Schritt.
    ;; Pakete kommen aus Nix (programs.emacs.extraPackages) – kein package.el.

    ;;; --- Aufräumen ---
    (setq inhibit-startup-message t
          initial-scratch-message ";; Scratch-Buffer. C-h t startet das Emacs-Tutorial.\n\n")

    ;; keine Backup-/Lock-Dateien; Customize-Kram in eigene Datei
    (setq make-backup-files nil
          create-lockfiles nil
          custom-file (locate-user-emacs-file "custom.el"))

    ;; Werkzeugleiste & Scrollbar weg; Menüleiste bleibt bewusst an (Lern-Hilfe!)
    (tool-bar-mode -1)
    (when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

    ;;; --- Sinnvolle Basics ---
    (setq use-short-answers t)              ; y/n statt yes/no
    (column-number-mode 1)                  ; Zeile:Spalte in der Modeline
    (global-display-line-numbers-mode 1)    ; Zeilennummern
    (show-paren-mode 1)                     ; passende Klammer hervorheben
    (electric-pair-mode 1)                  ; Klammern automatisch schließen

    ;; which-key zeigt mögliche Folge-Tasten (in Emacs 30 eingebaut) – super zum Lernen
    (when (fboundp 'which-key-mode)
      (which-key-mode 1))

    ;; Theme (eingebaut)
    (load-theme 'modus-vivendi t)

    ;;; --- Ab hier baust du auf. ---
    ;; Ein neues Paket hinzufügen:
    ;;   1. in modules/programs/emacs.nix unter extraPackages ergänzen (z.B. vertico)
    ;;   2. hier konfigurieren, z.B.:  (use-package vertico :config (vertico-mode 1))
    ;;   3. nixos-rebuild switch, dann Emacs neu starten.

    ;;; init.el ends here
  '';
in
{
  home-manager.users.${username} =
    { ... }:
    {
      programs.emacs = {
        enable = true;
        package = emacsPkg;

        # Bewusst leer – hier wächst deine Config. Beispiel:
        #   extraPackages = epkgs: with epkgs; [ vertico marginalia magit ];
        extraPackages = epkgs: [ ];
      };

      # init.el deklarativ nach ~/.config/emacs/init.el
      xdg.configFile."emacs/init.el".text = initEl;
    };
}
