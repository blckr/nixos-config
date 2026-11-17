{ config, lib, pkgs, ... }:
let
  cfg = config.modules.hardware.lenovo-amd;
in
{
  options.modules.hardware.lenovo-amd = {
    enable = lib.mkEnableOption "Enable hardware-specific optimizations for Lenovo AMD laptops";
  };

  config = lib.mkIf cfg.enable {
    boot.kernelParams = [
      "amdgpu.abmlevel=0"
    ];

    # Load amdgpu in stage 1 so Plymouth starts on the real driver. Otherwise
    # amdgpu takes over from simpledrm ~11s into boot and the screen blanks.
    hardware.amdgpu.initrd.enable = true;

    systemd.services.disable-wakeup-devices = {
      description = "Disable problematic ACPI and NIC wakeup sources";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.bash}/bin/sh -c '
          for dev in XHC0 XHC1 XHC2 XHC3 XHC4; do
            grep -q \"$dev.*enabled\" /proc/acpi/wakeup && echo \"$dev\" > /proc/acpi/wakeup || true
          done
          echo disabled > /sys/class/net/enp1s0f0/device/power/wakeup 2>/dev/null || true
        '";
        RemainAfterExit = "yes";
      };
    };

    # Reload ath11k_pci around suspend to allow PCIe ASPM while avoiding
    # the driver crash that ath11k_pci.disable_aspm=1 was working around
    powerManagement.powerDownCommands = lib.mkAfter ''
      modprobe -r ath11k_pci || true
    '';
    powerManagement.resumeCommands = lib.mkAfter ''
      modprobe ath11k_pci || true
    '';
  };
}
