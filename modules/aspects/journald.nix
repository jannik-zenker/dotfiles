{ lib, ... }:
{
  den.aspects.journald = { host, ... }: {
    nixos = {
      services.journald.extraConfig = lib.mkDefault (
        lib.optionalString (host.profile == "desktop") ''
          SystemMaxUse=500M
          SystemMaxFileSize=50M
          MaxRetentionSec=2weeks
          RateLimitInterval=30s
          RateLimitBurst=1000
          Compress=yes
        ''
        + lib.optionalString (host.profile == "server") ''
          SystemMaxUse=2G
          SystemMaxFileSize=200M
          MaxRetentionSec=3months
          Compress=yes
          RateLimitInterval=30s
          RateLimitBurst=10000
        ''
      );
    };
  };
}
