{
  den.aspects.jellyfin.nixos = {
    services.jellyfin = {
      enable = true;
      openFirewall = false; # We are doing that manually below
      user = "jellyfin";
      group = "jellyfin";

      forceEncodingConfig = true; # Disable imperative editing of encoding config

      # Hardware acceleration settings
      hardwareAcceleration = {
        enable = true;
        device = "/dev/dri/renderD128";
        type = "vaapi";
      };

      # Transcoding settings
      transcoding = {
        enableHardwareEncoding = true;
        enableSubtitleExtraction = true;

        hardwareDecodingCodecs = {
          h264 = true;
          hevc = true;
          hevc10bit = true;
          mpeg2 = true;
          vc1 = true;
          vp8 = true;
          vp9 = true;

          av1 = false;
          hevcRExt10bit = false;
          hevcRExt12bit = false;
        };

        hardwareEncodingCodecs = {
          hevc = true;
          av1 = false;
        };
      };
    };

    # Open http-port in vpn for setup
    networking.firewall.interfaces.wg0.allowedTCPPorts = [ 8096 ];
  };
}
