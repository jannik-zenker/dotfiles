{ inputs, ... }: {
  flake-file.inputs = {
    millennium = {
      url = "github:SteamClientHomebrew/Millennium?dir=packages/nix";
    };
  };

  den.aspects.gaming = {
    nixos = { pkgs, ... }: {
      nixpkgs.overlays = [ inputs.millennium.overlays.default ];
      programs.steam = {
        enable = true;
        # Millennium patches the Steam client to support custom
        # themes/plugins.
        package = pkgs.millennium-steam;
        # Community Proton build with extra compatibility fixes beyond
        # Steam's bundled Proton versions.
        extraCompatPackages = with pkgs; [ proton-ge-bin ];
      };

      # Create group "gaming" for multi-user access to game drives
      users.groups.gaming = { };
    };

    # gaming.nixos is host-scoped, so homeManager content must be routed to
    # users via provides.to-users rather than a flat homeManager key here,
    # which would be inert at host scope.
    provides.to-users.homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        heroic
        faugus-launcher
        lutris
        prismlauncher
      ];
    };
  };
}
