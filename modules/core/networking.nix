{
  pkgs,
  lib,
  ...
}:
{
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
    wifi.powersave = true;
    settings = {
      connection = {
        "ipv4.forwarding" = 0;
        "ipv6.forwarding" = 0;
      };
      device = {
        "wifi.scan-rand-mac-address" = "no";
      };
    };
  };

  networking.wireless.iwd.enable = true;
  networking.wireless.iwd.settings = {
    General = {
      EnableNetworkConfiguration = false;
    };
    Network = {
      NameResolvingService = "systemd";
    };
    # Disable scan-based roaming — ath11k (QCNFA765) repeatedly tries to auth
    # to the 5GHz BSS (+8 BSSID offset) and times out, causing ~75s wakeup
    # loops. DisableRoamingScan prevents proactive scanning for alternatives.
    Station = {
      DisableRoamingScan = true;
    };
  };

  services.resolved.enable = true;
  environment.systemPackages = [
    pkgs.iw
    # pkgs.iwd
    # pkgs.impala
    pkgs.bluetui
  ];

  # iwd (as NM backend) manages the WiFi interface exclusively and implements
  # its own power save — nl80211 PS via "iw dev wlan0 set power_save on" is
  # blocked by iwd. PowerTOP's "Wireless Power Saving" warning is a false
  # positive: iwd's internal PS is active, just not visible to nl80211 queries.

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        UserspaceHID = true;
        FastConnectable = true;
      };
      Policy = {
        AutoEnable = true;
        # Wait for the BT controller to be ready after s2idle resume
        ResumeDelay = 2;
      };
    };
  };

  # After s2idle suspend/resume the BT adapter can end up soft-blocked.
  # This ensures it is always powered on after any wakeup.
  systemd.services.bluetooth-resume = {
    description = "Re-enable Bluetooth after resume";
    wantedBy = [ "post-resume.target" ];
    after = [ "post-resume.target" "bluetooth.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.util-linux}/bin/rfkill unblock bluetooth";
      ExecStartPost = "${pkgs.bluez}/bin/bluetoothctl power on";
    };
  };
}
