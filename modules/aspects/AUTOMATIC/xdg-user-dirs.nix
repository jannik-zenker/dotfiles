{ lib, ... }:
{
  den.aspects.xdgUserDirs = {
    provides.to-users.homeManager = { host, ... }: {
      xdg.userDirs =
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
}
