{ inputs, ... }:
{
  flake-file.inputs = {
    niri-flake = {
      url = "github:sodiboo/niri-flake";
    };
  };

  den.aspects.niri = {
    provides.to-hosts.nixos = {
      imports = [ inputs.niri-flake.nixosModules.niri ];
      programs.niri.enable = true;
    };
  };
}
