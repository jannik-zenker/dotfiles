{
  flake-file.inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # `hm-host` is the entity kind Den's home-manager battery reads to configure
  # the NixOS-side `home-manager` module options (once per host, independent
  # of any per-user aspect). useGlobalPkgs/useUserPackages share the host's
  # nixpkgs instantiation with home-manager instead of re-evaluating a second
  # nixpkgs per user, and let user configs install to /etc/profiles/per-user/
  # instead  of the home directory of the users.
  den.schema.hm-host.includes = [
    {
      nixos.home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
      };
    }
  ];
}
