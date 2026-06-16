# Installs a bootloader based on metadata of the host
{ inputs, lib, ... }:
{
  # Get flake input for distro grub themes
  flake-file.inputs = {
    distro-grub-themes = {
      url = "github:AdisonCavani/distro-grub-themes";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.bootloader = { host, ... }: {

    # Install bootloader based on host metadata
    nixos = {
      boot.loader = {
        efi.canTouchEfiVariables = true;

        grub = lib.mkIf (host.bootloader == "grub") {
          enable = true;
          device = "nodev"; # For UEFI
          efiSupport = true;
          configurationLimit = 5;
        };

        systemd-boot = lib.mkIf (host.bootloader == "systemd-boot") {
          enable = true;
          configurationLimit = 5;
        };
      };

      # Import distro-grub-themes module
      imports = [ inputs.distro-grub-themes.nixosModules.${host.system}.default ];
      distro-grub-themes = lib.mkIf (host.bootloader == "grub") {
        enable = true;
        theme = "nixos";
      };
    };
  };
}
