{ inputs, lib, ... }: {
  flake-file.inputs = {
    distro-grub-themes = {
      url = "github:AdisonCavani/distro-grub-themes";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.bootloader.nixos = { host, ... }: {
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

    imports = [ inputs.distro-grub-themes.nixosModules.${host.system}.default ];
    distro-grub-themes = lib.mkIf (host.bootloader == "grub") {
      enable = true;
      theme = "nixos";
    };
  };
}
