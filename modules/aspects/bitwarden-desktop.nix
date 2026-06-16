{
  den.aspects.bitwardenDesktop = {
    homeManager = { pkgs, ... }: {
      # TEMPORARY FIX FOR UPSTREAM ISSUE IN bitwarden-desktop
      nixpkgs.overlays = [
        (final: prev: {
          bitwarden-desktop = prev.bitwarden-desktop.override {
            electron_39 = final.electron_39-bin;
          };
        })
      ];

      nixpkgs.config.permittedInsecurePackages = [
        "electron-39.8.10"
      ];

      home.packages = with pkgs; [ bitwarden-desktop ];
    };
  };
}
