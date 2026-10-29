{
  config,
  lib,
  ...
}:

{

  options.modules.powerManagement = {
    profile = lib.mkOption {
      type = lib.types.enum [ "tlp" "none" ];
      default = "none";
      description = "Which power management profile to use.";
    };
  };

  config = {

    services.tlp = lib.mkIf (config.modules.powerManagement.profile == "tlp") {
      enable = true;
      settings = {
        TLP_ENABLE = 1;
        CPU_SCALING_GOVERNOR_ON_AC = "schedutil";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

        # Disable AMD Core Performance Boost on battery — single biggest saving on AMD
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;
        CPU_HWP_DYN_BOOST_ON_AC = 1;
        CPU_HWP_DYN_BOOST_ON_BAT = 0;

        # PCIe power management
        # "on" on AC avoids latency spikes from devices waking up
        RUNTIME_PM_ON_AC = "on";
        RUNTIME_PM_ON_BAT = "auto";
        PCIE_ASPM_ON_AC = "default";
        PCIE_ASPM_ON_BAT = "powersupersave";

        # Wi-Fi: NM sets power-save, TLP must not override it
        WIFI_PWR_ON_AC = "off";
        WIFI_PWR_ON_BAT = "off";

        # Wake-on-LAN disabled — prevents NICs from blocking power-gating
        WOL_DISABLE = "Y";

        USB_AUTOSUSPEND = 1;
        USB_EXCLUDE_AUDIO = 1;
        SOUND_POWER_SAVE_ON_BAT = 1;
        SOUND_POWER_SAVE_CONTROLLER = 1;

        # P14s uses amdgpu driver, not radeon — RADEON_DPM_* is a no-op here
        # AMD GPU power is managed via PLATFORM_PROFILE instead
        PLATFORM_PROFILE_ON_AC = "balanced";
        PLATFORM_PROFILE_ON_BAT = "low-power";

        START_CHARGE_THRESH_BAT0 = 75;
        STOP_CHARGE_THRESH_BAT0 = 85;
      };
    };
  };

}
