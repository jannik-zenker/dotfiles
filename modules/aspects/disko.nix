{ inputs, ... }:
{
  flake-file.inputs = {
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.disko.nixos = {
    imports = [ inputs.disko.nixosModules.disko ];
  };
}
