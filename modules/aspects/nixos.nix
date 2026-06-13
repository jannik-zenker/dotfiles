{
  den.aspects.nixos = {
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
    };
  };
}
