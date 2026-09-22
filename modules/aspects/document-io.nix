{
  den.aspects.documentIo.nixos = {
    services.printing.enable = true;

    # Detect printers in network
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    hardware.sane.enable = true;
  };
}
