{
  den.aspects.xdgUserDirs = {
    # Only create user dirs on desktops and laptops
    provied.to-users.homeManager.xdg.userDirs =
      { host, ... }:
      (builtins.elem host.profile [
        "desktop"
        "laptop"
      ])
        {
          enable = true;
          createDirectories = true;
        };
  };
}
