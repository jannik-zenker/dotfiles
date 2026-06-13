{
  den.aspects.nixos = { host, ... }: {
    nixos = {
      nix = {
        # Enable flake functionality and new CLI
        settings.experimental-features = [
          "nix-command"
          "flakes"
        ];
        optimise = {
          automatic = true;
          dates = [ "05:00" ];
        };
        # Automatic garbage collection
        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 14d";
          persistent = true; # If host was offline -> collect garbage on next boot
        };
      };
      systemd.timers.nix-optimise.timerConfig.Persistent = true; # If host was offline during optimize time -> do it on next boot

      # locale settings
      i18n = {
        defaultLocale = "de_DE.UTF-8";
        extraLocaleSettings = {
          LC_ADDRESS = "de_DE.UTF-8";
          LC_COLLATE = "de_DE.UTF-8";
          LC_CTYPE = "de_DE.UTF-8";
          LC_IDENTIFICATION = "de_DE.UTF-8";
          LC_MONETARY = "de_DE.UTF-8";
          LC_MESSAGES = "en_GB.UTF-8";
          LC_MEASUREMENT = "de_DE.UTF-8";
          LC_NAME = "de_DE.UTF-8";
          LC_NUMERIC = "de_DE.UTF-8";
          LC_PAPER = "de_DE.UTF-8";
          LC_TELEPHONE = "de_DE.UTF-8";
          LC_TIME = "de_DE.UTF-8";
        };
      };

      # Take local time for desktops, UTC for servers and as a fallback
      time.timeZone = if host.profile == "desktop" then "Europe/Berlin" else "UTC";

      # TTY console settings
      console = {
        keyMap = "de-latin1";
        font = "iso01-12x22";
      };
    };
  };
}
