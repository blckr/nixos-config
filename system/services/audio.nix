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
      wireplumber.enable = true;
      jack.enable = true;
    };

    programs.dconf.enable = true;
    security.rtkit.enable = true;
    environment.systemPackages = [
      pkgs.wiremix
    ];
  };

}
