# Define Metadata that has to be set by every host
{ lib, ... }:
{
  den.schema = {
    host = {
      options = {
        bootloader = lib.mkOption {
          type = lib.types.enum [
            "grub"
            "systemd-boot"
          ];
          default = "systemd-boot";
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
            "server"
          ];
          description = "What the host is used as";
        };
      };
    };
  };
}
