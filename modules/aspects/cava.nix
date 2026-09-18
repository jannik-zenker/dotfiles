{
  den.aspects.cava.homeManager = { config, lib, ... }: {
    home.activation.cavaConfig = lib.hm.dag.entryBefore [ "writeBoundary" ] ''
      rm -f "${config.xdg.configHome}/cava/config"
    '';

    programs.cava.enable = true;
  };
}
