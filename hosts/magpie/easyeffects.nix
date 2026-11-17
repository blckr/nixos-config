# Voice chain for the MX Brio; its volume is set at the source, the compressor adds the loudness
let
  device = "alsa_input.usb-046d_MX_Brio_2415LZ53BF08-04.analog-stereo";
  # easyeffects keys autoload files by the route description, not its name
  route = "Headset Microphone";
in
{
  services.easyeffects = {
    enable = true;
    # Keys and labels as in easyeffects' *_preset.cpp; missing keys fall back to the defaults
    extraPresets.mx-brio.input = {
      blocklist = [ ];
      plugins_order = [
        "filter#0"
        "deepfilternet#0"
        "compressor#0"
        "limiter#0"
      ];
      "filter#0" = {
        bypass = false;
        type = "High-pass";
        frequency = 90.0;
        slope = "x2";
      };
      # Removes keyboard clicks far better than RNNoise
      "deepfilternet#0" = {
        bypass = false;
      };
      "compressor#0" = {
        bypass = false;
        mode = "Downward";
        threshold = -20.0;
        ratio = 3.0;
        attack = 10.0;
        release = 100.0;
        makeup = 8.0;
      };
      "limiter#0" = {
        bypass = false;
        threshold = -1.0;
        # Otherwise it raises everything up to the threshold, noise included
        gain-boost = false;
      };
    };
  };

  # Loads the preset whenever the MX Brio appears; --load-preset does nothing at service start
  xdg.dataFile."easyeffects/autoload/input/${device}:${route}.json".text = builtins.toJSON {
    inherit device;
    device-description = "MX Brio Analog Stereo";
    device-profile = route;
    preset-name = "mx-brio";
  };
}
