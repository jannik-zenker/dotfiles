# Contains global settings across all hosts, users and standalone homes
{ lib, den, ... }: {
  den = {
    default = {
      nixos =
        {
          host,
          lib,
          modulesPath,
          ...
        }:
        {
          # Every physical host needs its scanned hardware-configuration import
          # and a platform setup derived from its own metadata.
          imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
          nixpkgs.hostPlatform = lib.mkDefault host.system;
        };

      homeManager = { osConfig, ... }: { home.stateVersion = osConfig.system.stateVersion; };
    };

    schema = {
      host = {
        # Include host modules that should be active by default
        includes = [
          den.aspects.bootloader
          den.aspects.defaultPackages
          den.aspects.disko
          den.aspects.firmware
          den.aspects.git
          den.aspects.graphics
          den.aspects.journald
          den.aspects.nixos
          den.aspects.security
          den.aspects.sopsNix
          den.aspects.xdg
          den.batteries.hostname
        ];
      };

      user = {
        # Enable home-manager class evaluation by default for every user
        classes = lib.mkDefault [ "homeManager" ];
        # Create users from user declarations in host declarations
        includes = [
          den.batteries.define-user
          den.aspects.environment
          den.aspects.xdg
        ];
      };
    };
  };
}
