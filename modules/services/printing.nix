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
        # Raw-Socket (JetDirect) statt IPP-Everywhere: der brlaser-Treiber
        # schickt kompakte, druckereigene Daten (HBP) an Port 9100 – dadurch
        # kein 600-dpi-pwg-raster mehr, das den kleinen Drucker-RAM überläuft
        # und große Jobs abbrechen ließ.
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
