{ lib, ... }:
let
  mkSubvolume =
    {
      mountpoint,
      mountOptions ? [
        "compress=zstd"
        "noatime"
      ],
    }:
    {
      inherit mountpoint mountOptions;
    };
in
{
  # Builds a disko `disk.system` device with the EFI + swap layout shared by
  # every host, leaving only the main partition's content (and the disk
  # device path itself) host-specific. Merge the result into a NixOS config,
  # e.g.:
  #   self.lib.mkStandardDisk {
  #     device = "/dev/disk/by-id/...";
  #     content = {
  #       type = "btrfs";
  #       subvolumes."@root".mountpoint = "/";
  #     };
  #   }
  config.flake.lib = {
    mkStandardDisk =
      {
        device,
        content,
        swapSize ? "4G",
      }:
      {
        disko.devices.disk.system = {
          inherit device;
          type = "disk";
          content = {
            type = "gpt";
            partitions = {
              EFI = {
                type = "EF00";
                size = "1G";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [ "umask=0077" ];
                };
              };

              SWAP = {
                size = swapSize;
                content.type = "swap";
              };

              NIXOS = {
                size = "100%";
                inherit content;
              };
            };
          };
        };
      };

    inherit mkSubvolume;

    # Builds a disko btrfs `subvolumes` attrset from a plain name -> mountpoint
    # mapping, applying mkSubvolume's default mountOptions to each one. Pass a
    # full { mountpoint; mountOptions; } attrset instead of a string for any
    # subvolume that needs different mountOptions. e.g.:
    #   self.lib.mkSubvolumes {
    #     "@root" = "/";
    #     "@nix" = "/nix";
    #     "@varlib/immich" = "/var/lib/immich";
    #   }
    mkSubvolumes =
      subvolumes:
      lib.mapAttrs (
        _: spec: mkSubvolume (if builtins.isString spec then { mountpoint = spec; } else spec)
      ) subvolumes;
  };
}
