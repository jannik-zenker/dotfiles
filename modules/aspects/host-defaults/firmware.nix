{ lib, ... }: {
  den.aspects.firmware.nixos =
    { config, host, ... }:
    {
      nixpkgs.config.allowUnfree = true; # needed for proprietary firmware
      hardware.enableAllFirmware = true;
      services.fwupd.enable = true;

      hardware.cpu.${host.cpu}.updateMicrocode =
        lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
