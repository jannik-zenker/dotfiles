# Declares the freeform metadata schema for `host`/`user` entities. This is
# pure data, not behavior: aspects elsewhere read these fields (e.g.
# aspects/host-defaults/bootloader.nix reads `host.bootloader`) to decide
# what to configure. Host fields have no default, so every host declared in
# host-declarations.nix is forced to state these facts explicitly.
{ lib, ... }: {
  den.schema = {
    host = {
      options = {
        bootloader = lib.mkOption {
          type = lib.types.enum [
            "grub"
            "systemd-boot"
          ];
        };

        cpu = lib.mkOption {
          type = lib.types.enum [
            "amd"
            "intel"
          ];
          description = "CPU manufacturer";
        };

        gpu = lib.mkOption {
          type = lib.types.enum [
            "nvidia"
            "amd"
            "intel"
            "none"
          ];
          description = "GPU manufacturer";
        };

        profile = lib.mkOption {
          type = lib.types.enum [
            "desktop"
            "laptop"
            "server"
          ];
          description = "What the host is used as";
        };
      };
    };

    # Unlike host fields, these default to null: not every user needs git
    # identity configured, and aspects/host-defaults/git.nix only sets
    # `programs.git.settings.user.*` when a value is actually present.
    user = {
      options = {
        gitName = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Git username";
        };

        gitMail = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Git email-adress";
        };
      };
    };
  };
}
