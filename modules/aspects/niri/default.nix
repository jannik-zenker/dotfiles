{
  den.aspects.niri = {
    nixos = { pkgs, ... }: {
      programs.niri = {
        enable = true;
        useNautilus = true;
      };

      # Install dependencies
      security.polkit.enable = true;
      services.gnome.gnome-keyring.enable = true;
      programs.xwayland.enable = true;
      environment.systemPackages = with pkgs; [
        bibata-cursors
        xwayland-satellite
      ];

      # polkit-gnome service
      systemd.user.services.polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        unitConfig.ConditionEnvironment = "XDG_SESSION_DESKTOP=niri";
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };
  };
}
