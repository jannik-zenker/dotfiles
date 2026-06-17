# Contains global settings across all hosts, users and standalone homes
{ lib, den, ... }:
{
  den = {
    default = {
      nixos = { pkgs, ... }: {
        nixpkgs.config.allowUnfree = true; # needed for proprietary firmware
        hardware.enableAllFirmware = true;
        services.fwupd.enable = true;

        # Generate host ssh-keys by default
        services.openssh.generateHostKeys = true;
      };

      homeManager = {
        nixpkgs.config.allowUnfree = true;
      };
    };

    schema = {
      host = {
        # Set hostnames from host declarations, install bootloader and the disko module
        includes = [
          den.aspects.bootloader
          den.aspects.defaultPackages
          den.aspects.disko
          den.aspects.git
          den.aspects.graphics
          den.aspects.journald
          den.aspects.nixos
          den.aspects.security
          den.aspects.xdgUserDirs
          den.batteries.hostname
        ];
      };

      user = {
        # Enable home-manager class evaluation by default for every user
        classes = lib.mkDefault [ "homeManager" ];
        # Create users from user declarations in host declarations
        includes = with den.batteries; [ define-user ];
      };
    };
  };
}
