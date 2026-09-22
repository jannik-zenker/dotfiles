{
  den.aspects.cava.homeManager = { config, lib, ... }: {
    # cava rewrites its own config file at runtime (e.g. when sensitivity is
    # adjusted interactively), turning home-manager's managed symlink into a
    # plain file. Remove it before each activation so home-manager can always
    # recreate the symlink instead of failing with "already exists".
    home.activation.cavaConfig = lib.hm.dag.entryBefore [ "writeBoundary" ] ''
      rm -f "${config.xdg.configHome}/cava/config"
    '';

    programs.cava.enable = true;
  };
}
