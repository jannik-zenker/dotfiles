{
  den.aspects.bluetooth = {
    nixos = {
      hardware.bluetooth = {
        enable = true;
        settings.General = {
          # BlueZ's battery-percentage D-Bus interface is gated behind this,
          # needed for device battery levels to show up in the UI.
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
