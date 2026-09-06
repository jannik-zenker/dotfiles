{ lib, ... }:
{
  den.aspects.journald = { host, ... }: {
    nixos = {
      services.journald.settings.Journal = lib.mkDefault (
        if builtins.elem host.profile [ "desktop" "laptop" ] then
          {
            SystemMaxUse = "500M";
            SystemMaxFileSize = "50M";
            MaxRetentionSec = "2weeks";
            RateLimitInterval = "30s";
            RateLimitBurst = 1000;
            Compress = "yes";
          }
        else if host.profile == "server" then
          {
            SystemMaxUse = "2G";
            SystemMaxFileSize = "200M";
            MaxRetentionSec = "3months";
            Compress = "yes";
            RateLimitInterval = "30s";
            RateLimitBurst = 10000;
          }
        else
          { }
      );
    };
  };
}
