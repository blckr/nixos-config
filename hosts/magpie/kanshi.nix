{
  username,
  ...
}:
let
  internalDisplay = {
    criteria = "Lenovo Group Limited 0x414B Unknown";
    mode = "2880x1800";
    status = "enable";
    scale = 1.5; # Per default to 1.5
  };
in
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
                (
                  internalDisplay
                  // {
                    scale = 1.4;
                    position = "0,0";
                  }
                )
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
                (
                  internalDisplay
                  // {
                    mode = "2880x1800@120.000";
                    position = "0,1440";
                  }
                )
              ];
            };
          }
          {
            profile = {
              name = "lab-pc30";
              outputs = [
                (
                  internalDisplay
                  // {
                    position = "${builtins.toString ((2560 - 1920) / 2)},${builtins.toString 1440}";
                  }
                )
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
              name = "family";
              outputs = [
                (
                  internalDisplay
                  // {
                    position = "${builtins.toString ((1920 - 1280) / 2)},${builtins.toString 1080}";
                  }
                )
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
              name = "lab-pcxx";
              outputs = [
                (
                  internalDisplay
                  // {
                    position = "${builtins.toString ((2560 - 1920) / 2)},${builtins.toString 1440}";
                  }
                )
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
          {
            profile = {
              name = "mirror";
              outputs = [
                (
                  internalDisplay
                  // {
                    scale = 1.4;
                    position = "0,0";
                  }
                )
                {
                  criteria = "*";
                  status = "enable";
                  position = "0,0";
                }
              ];
            };
          }
        ];
      };
    };
}
