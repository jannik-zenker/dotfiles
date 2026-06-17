{ inputs, ... }:
{
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
        package = pkgs.millennium-steam;
        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
      };

      # Create group "gaming" for multi-user access to game drives
      users.groups.gaming = { };
    };

    provides.to-users.homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        heroic
        faugus-launcher
        lutris
      ];
    };
  };
}
