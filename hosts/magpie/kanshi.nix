# Kanshi defines how displays should be ordered in relation to another.
#
# Execute `niri msg outputs` to find the name of the registered screens.
{
  username,
  ...
}:
{
  home-manager.users.${username} =
    {
      config,
      ...
    }:
    {
      services.kanshi = {
        enable = true;
        settings = [
          {
            profile = {
              name = "mobile";
              outputs = [
                {
                  criteria = "Lenovo Group Limited 0x414B Unknown";
                  mode = "2880x1800";
                  status = "enable";
                  scale = 1.4;
                  position = "0,0";
                }
              ];
            };
          }
          {
            profile = {
              name = "home-3";
              outputs = [
                {
                  criteria = "Dell Inc. DELL S2725QS DQHP364";
                  mode = "2560x1440@119.998";
                  scale = 1.0;
                  position = "2560,0";
                }
                {
                  criteria = "Lenovo Group Limited Q27q-20 UPP023CY";
                  mode = "2560x1440@74.991";
                  scale = 1.0;
                  position = "0,0";
                }
                {
                  criteria = "Lenovo Group Limited 0x414B Unknown";
                  mode = "2880x1800@120.000";
                  scale = 1.5; # 2880 / 1.5 = 1920 logische Breite
                  position = "0,1440";
                }
              ];
            };
          }
          {
            profile = {
              # Laptop screen below external Screen
              name = "lab-pc30";
              outputs = [
                {
                  criteria = "Lenovo Group Limited 0x414B Unknown";
                  mode = "2880x1800";
                  status = "enable";
                  scale = 1.5;
                  # 1920 comes from 2880 / 1.5 (Scaling) = 1920
                  position = "${builtins.toString ((2560 - 1920) / 2)},${builtins.toString 1440}";
                }
                {
                  criteria = "Dell Inc. DELL U2715H GH85D86M06FS";
                  mode = "2560x1440";
                  status = "enable";
                  scale = 1.0;
                  position = "0,0";
                }
              ];
            };
          }
          {
            profile = {
              # Laptop screen below external Screen
              name = "family";
              outputs = [
                {
                  criteria = "Lenovo Group Limited 0x414B Unknown";
                  mode = "2880x1800";
                  status = "enable";
                  scale = 1.5;
                  # 1280 comes from 1920 / 1.5 (Scaling) = 1280
                  position = "${builtins.toString ((1920 - 1280) / 2)},${builtins.toString 1080}";
                }
                {
                  criteria = "PNP(AOC) 27G2G4 0x0001AA0D";
                  mode = "1920x1080@120.000";
                  status = "enable";
                  scale = 1.0;
                  position = "0,0";
                }
              ];
            };
          }
          {
            profile = {
              # Laptop screen below external Screen
              name = "lab-pcxx";
              outputs = [
                {
                  criteria = "Lenovo Group Limited 0x414B Unknown";
                  mode = "2880x1800";
                  status = "enable";
                  scale = 1.5;
                  # 1920 comes from 2880 / 1.5 (Scaling) = 1920
                  position = "${builtins.toString ((2560 - 1920) / 2)},${builtins.toString 1440}";
                }
                {
                  criteria = "Dell Inc. DELL P2723DE B35B0N3";
                  mode = "2560x1440@59.951";
                  status = "enable";
                  scale = 1.0;
                  position = "0,0";
                }
              ];
            };
          }
        ];
      };
    };
}
