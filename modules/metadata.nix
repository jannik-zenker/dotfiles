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
