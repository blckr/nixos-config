{
  ...
}:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [
    "amd_pstate=active"
    "rtc_cmos.use_acpi_alarm=1"
    "acpi.ec_no_wakeup=1"
  ];
}
