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
          ...
        }:
        {
          nixpkgs.config.allowUnfree = true; # needed for proprietary firmware
          hardware.enableAllFirmware = true;
          services.fwupd.enable = true;

          # Generate host ssh-keys by default
          services.openssh.generateHostKeys = true;

          # Turn off mutable users since they are managed decleratively
          users.mutableUsers = false;

          # Get user/root password sops secrets
          sops.secrets =
            lib.mapAttrs' (
              name: _:
              lib.nameValuePair "${name}-password" {
                sopsFile = ../secrets/${host.name}/passwords.yaml;
                neededForUsers = true;
              }
            ) host.users
            // {
              "root-password" = {
                sopsFile = ../secrets/${host.name}/passwords.yaml;
                neededForUsers = true;
              };
            };

          # Set passwords for root and users
          users.users =
            lib.mapAttrs (name: _: {
              hashedPasswordFile = config.sops.secrets."${name}-password".path;
            }) host.users
            // {
              root.hashedPasswordFile = config.sops.secrets."root-password".path;
            };
        };

      homeManager = {
        nixpkgs.config.allowUnfree = true;
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
        includes = with den.batteries; [ define-user ];
      };
    };
  };
}
