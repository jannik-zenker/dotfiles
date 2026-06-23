{ lib, ... }:
{
  den.aspects.xdg = {
    provides.to-users.homeManager = { host, ... }: {
      xdg = {
        enable = true;
        userDirs =
          lib.mkIf
            (builtins.elem host.profile [
              "desktop"
              "laptop"
            ])
            {
              enable = true;
              createDirectories = true;
            };
      };
    };
  };
}
