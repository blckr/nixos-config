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
    # ath11k keeps trying to roam to the 5 GHz BSS and times out (~75 s wakeup loops)
    Station = {
      DisableRoamingScan = true;
    };
  };

  # iwd started before wlan0 exists never picks it up ("No default interface for wiphy 0")
  systemd.services.iwd = {
    wants = [ "sys-subsystem-net-devices-wlan0.device" ];
    after = [ "sys-subsystem-net-devices-wlan0.device" ];
  };

  services.resolved.enable = true;
  environment.systemPackages = [
    pkgs.iw
    # pkgs.iwd
    # pkgs.impala
    pkgs.bluetui
  ];

  # PowerTOP's "Wireless Power Saving" warning is a false positive: iwd does its own power save

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

  # The adapter can end up soft-blocked after s2idle resume
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
