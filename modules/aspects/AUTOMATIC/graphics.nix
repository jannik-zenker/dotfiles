{ lib, ... }:
{
  den.aspects.graphics = { host, ... }: {
    nixos =
      { config, pkgs, ... }:
      lib.mkMerge [
        (lib.mkIf (host.gpu != "none") {
          hardware.graphics = {
            enable = true;
            enable32Bit = true;
          };
        })
        (lib.mkIf (host.gpu == "intel") {
          hardware.graphics.extraPackages = with pkgs; [
            intel-media-driver
            vpl-gpu-rt
            intel-compute-runtime
          ];
          environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";
          boot = {
            kernelParams = [ "i915.enable_guc=3" ];
            initrd.kernelModules = [ "i915" ];
          };
        })
        (lib.mkIf (host.gpu == "amd") {
          boot.initrd.kernelModules = [ "amdgpu" ];
        })
        (lib.mkIf (host.gpu == "nvidia") {
          services.xserver.videoDrivers = [ "nvidia" ];
          hardware.nvidia = {
            open = if lib.versionOlder config.hardware.nvidia.package.version "560" then false else true;
            powerManagement.enable = true;
          };
          boot.initrd.kernelModules = [ "nvidia" ];
        })
      ];
  };
}
