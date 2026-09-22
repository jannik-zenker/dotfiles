# The single place deciding which shared config/aspects apply to *every*
# host, user and home, on top of whatever each entity's own aspect adds.
{ lib, den, ... }: {
  den = {
    default = {
      # `den.default.*` injects config directly into every entity of a class
      # (no `includes` wiring needed), unlike aspects which must be pulled in
      # explicitly. Used here for config every physical host needs
      # regardless of its own metadata.
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

      # Tie home-manager's state version to the host's system state version
      # instead of tracking a second value that could drift out of sync.
      homeManager = { osConfig, ... }: { home.stateVersion = osConfig.system.stateVersion; };
    };

    schema = {
      host = {
        # Aspects/batteries every host gets regardless of its own meta-aspect
        # (sirene.nix, reacher.nix, ...); per-host aspects add on top of this.
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
        # mkDefault (not a plain assignment) so a specific user could opt out
        # of home-manager entirely if it ever needed to.
        classes = lib.mkDefault [ "homeManager" ];
        # `define-user` is what turns the `users.<name> = { ... }` entries in
        # host-declarations.nix into real user entities in the first place.
        includes = [
          den.batteries.define-user
          den.aspects.environment
          den.aspects.xdg
        ];
      };
    };
  };
}
