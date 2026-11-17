{
  pkgs,
  ...
}:
{
  config = {
    services.pulseaudio.enable = false;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # Discord's automatic gain control keeps lowering the microphone volume
      extraConfig.pipewire-pulse."50-discord-fixed-mic"."pulse.rules" = [
        {
          matches = [ { "application.process.binary" = "~.*[Dd]iscord.*"; } ];
          actions.quirks = [ "block-source-volume" ];
        }
      ];
      wireplumber = {
        enable = true;
        # Never fall back to the low-quality headset profile; the microphone is a separate device
        extraConfig."51-no-bt-autoswitch"."wireplumber.settings"."bluetooth.autoswitch-to-headset-profile" =
          false;
      };
      jack.enable = true;
    };

    programs.dconf.enable = true;
    security.rtkit.enable = true;
    environment.systemPackages = [
      pkgs.wiremix
    ];
  };

}
