# Contains global settings across all hosts, users and standalone homes
{ lib, den, ... }:
{
  den = {
    default = {
      nixos =
        {
          config,
          host,
          lib,
          modulesPath,
          ...
        }:
        let
          passwordUsers = (lib.attrNames host.users) ++ [ "root" ];
        in
        {
          # Every physical host needs its scanned hardware-configuration import
          # and a platform + microcode setup derived from its own metadata.
          imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
          nixpkgs.hostPlatform = lib.mkDefault host.system;
          hardware.cpu.${host.cpu}.updateMicrocode =
            lib.mkDefault config.hardware.enableRedistributableFirmware;

          nixpkgs.config.allowUnfree = true; # needed for proprietary firmware
          hardware.enableAllFirmware = true;
          services.fwupd.enable = true;

          # Generate host ssh-keys by default
          services.openssh.generateHostKeys = true;

          # Turn off mutable users since they are managed decleratively
          users.mutableUsers = false;

          # Get user/root password sops secrets
          sops.secrets = lib.genAttrs (map (name: "${name}-password") passwordUsers) (_: {
            sopsFile = ../secrets/${host.name}/passwords.yaml;
            neededForUsers = true;
          });

          # Set passwords for root and users
          users.users = lib.genAttrs passwordUsers (name: {
            hashedPasswordFile = config.sops.secrets."${name}-password".path;
          });
        };

      homeManager =
        { osConfig, ... }:
        {
          home.stateVersion = osConfig.system.stateVersion;
        };
    };

    schema = {
      host = {
        # Include host modules that should be active by default
        includes = [
          den.aspects.bootloader
          den.aspects.defaultPackages
          den.aspects.disko
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
        includes = [ den.batteries.define-user ];
      };
    };
  };
}
