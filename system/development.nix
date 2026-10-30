{ pkgs, username, ... }:

{
  users.users.${username}.extraGroups = [ "dialout" ];

  # Add udev rules for ESP32 and other development boards
  services.udev.packages = with pkgs; [
    platformio-core
    openocd
  ];

  # Additional udev rules for ESP32 specifically
  services.udev.extraRules = ''
    # ESP32-S2 and ESP32-S3 boards
    SUBSYSTEM=="usb", ATTR{idVendor}=="303a", MODE="0666", GROUP="dialout", ENV{ID_MM_DEVICE_IGNORE}="1"
    
    # CP210X USB to UART Bridge (common on ESP32 dev boards)
    SUBSYSTEM=="tty", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", MODE="0666", GROUP="dialout", ENV{ID_MM_DEVICE_IGNORE}="1"
    
    # CH340 USB to UART Bridge  
    SUBSYSTEM=="tty", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="7523", MODE="0666", GROUP="dialout", ENV{ID_MM_DEVICE_IGNORE}="1"
    
    # FTDI USB to UART Bridge
    SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", MODE="0666", GROUP="dialout", ENV{ID_MM_DEVICE_IGNORE}="1"
  '';
}

