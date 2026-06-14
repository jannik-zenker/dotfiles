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
        defaultBrowser = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Default browser command";
        };

        defaultFileBrowser = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Default file-browser command";
        };

        defaultTerminal = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Default terminal command";
        };

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
