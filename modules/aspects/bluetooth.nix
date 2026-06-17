{
  den.aspects.bluetooth = {
    nixos = {
      hardware.bluetooth = {
        enable = true;
        settings.General = {
          Experimental = true;
          FastConnectable = true;
        };
      };
    };

    homeManager = {
      services.blueman-applet.enable = true;
    };
  };
}
