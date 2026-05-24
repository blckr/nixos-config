{
  config,
  lib,
  pkgs,
  username,
  ...
}:
lib.mkIf config.modules.desktop.enable (
  let
    ppdEnabled = config.modules.powerManagement.profile == "ppd";
    fnottEnabled = config.modules.apps.fnott.enable == true;
  in
  {
    # Quickshell Paket installieren
    environment.systemPackages = with pkgs; [
      quickshell
      pwvucontrol
      playerctl
    ];

    home-manager.users.${username} =
      { ... }:
      {
        # Quickshell erwartet seine Hauptkonfiguration in ~/.config/quickshell/shell.qml
        xdg.configFile."quickshell/shell.qml".text = ''
           import QtQuick
           import QtQuick.Layouts
           import Quickshell
           import Quickshell.Wayland
           import Quickshell.Services.Pipewire // Für Audio
           import Quickshell.Io // Ersetzt die Bash-Skripte

           ShellRoot {
             PanelWindow {
               anchors {
                 left: parent.left
                 right: parent.right
                 bottom: parent.bottom
               }
               height: 26
               color: "#e6212733" // rgba(33,39,51, 0.9)

               RowLayout {
                 anchors.fill: parent
                 spacing: 4

                 // ################ LINKS ################
                 RowLayout {
                   Layout.alignment: Qt.AlignLeft
                   spacing: 8

                   // Workspaces (Beispielhaft als Platzhalter für Niri-Integration)
                   Text { 
                     text: ""
                     font.bold: true
                     color: "#cccac2"
                   }

                   // MPRIS (Media Player)
                   MprisPlayer {
                     id: mpris
                   }
                   Text {
                     text: mpris.playing ? "󰝚 " + mpris.title : ""
                     color: "#cccac2"
                     visible: mpris.title !== ""
                   }
                 }

                 // ################ CENTER ################
                 RowLayout {
                   Layout.alignment: Qt.AlignCenter
                   Text {
                     text: "Niri Window Title" // Kann via Wayland-Toplevel ausgelesen werden
                     color: "#cccac2"
                   }
                 }

                 // ################ RECHTS ################
                 RowLayout {
                   Layout.alignment: Qt.AlignRight
                   spacing: 6

                   // VPN Status (Überprüft nmcli nativ per Prozess-Reader)
                   Process {
                     id: vpnCheck
                     command: ["nmcli", "-t", "-f", "NAME,TYPE", "connection", "show", "--active"]
                     running: true
                     stdoutParser: function(line) {
                       if (line.includes("vpn") || line.includes("wireguard")) {
                         vpnText.text = line.split(":")[0];
                         vpnText.color = "#ffad66"; // Warning Farbe
                       }
                     }
                   }
                   Text { id: vpnText; text: ""; font.family: "JetBrainsMono Nerd Font" }

                   // Audio / Pulseaudio Ersatz
                   Text {
                     text: Pipewire.defaultSink.muted ? "" : ""
                     color: Pipewire.defaultSink.muted ? "#ffad66" : "#cccac2"
                     MouseArea {
                       anchors.fill: parent
                       onClicked: ObjectCreator.createPopupMenu() // Öffnet ein Qt-Menü
                     }
                   }

                   // Batterie
                   Text {
                     text: "󰁹 " + Battery.percentage + "%"
                     color: Battery.percentage < 20 ? "red" : "#cccac2"
                   }

                   // Uhrzeit
                   Text {
                     text: Qt.formatDateTime(new Date(), "yy-MM-dd HH:mm")
                     color: "#cccac2"
                     font.bold: true
                   }
                 }
               }
              panelMode: PanelMode.Dock
            }
          }
        '';
      };
  }
)
