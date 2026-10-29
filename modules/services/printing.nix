{ pkgs, ... }:

{
  services = {
    printing = {
      enable = true;
      drivers = with pkgs; [ cups-filters brlaser ];
    };

    avahi = {
      enable = true;
      openFirewall = true;
      nssmdns4 = true;
    };
  };

  hardware.printers = {
    ensurePrinters = [
      {
        name = "Brother_HL2350SW";
        location = "Home";
        # Raw socket + brlaser instead of IPP Everywhere: the 600dpi PWG raster
        # overflows the printer's RAM and aborts large jobs.
        deviceUri = "socket://192.168.178.137:9100";
        model = "drv:///brlaser.drv/brl2350d.ppd";
        ppdOptions = {
          PageSize = "A4";
        };
      }
    ];
    ensureDefaultPrinter = "Brother_HL2350SW";
  };
}
