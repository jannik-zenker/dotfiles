{ lib, ... }: {
  den.aspects.journald.nixos = { host, ... }: {
    # Servers run more services and need longer retention for debugging, so
    # they get bigger storage/rate-limit budgets than desktops/laptops.
    services.journald.settings.Journal = lib.mkDefault (
      if host.profile == "server" then
        {
          SystemMaxUse = "2G";
          SystemMaxFileSize = "200M";
          MaxRetentionSec = "3months";
          Compress = "yes";
          RateLimitInterval = "30s";
          RateLimitBurst = 10000;
        }
      else
        {
          SystemMaxUse = "500M";
          SystemMaxFileSize = "50M";
          MaxRetentionSec = "2weeks";
          RateLimitInterval = "30s";
          RateLimitBurst = 1000;
          Compress = "yes";
        }
    );
  };
}
