{
  den.aspects.cava = {
    homeManager =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        home.activation.cavaConfig = lib.hm.dag.entryBefore [ "writeBoundary" ] ''
          rm -f "${config.xdg.configHome}/cava/config"
        '';

        programs.cava = {
          enable = true;
          settings = {
            color.theme = lib.mkIf (lib.attrByPath [ "programs" "noctalia" "enable" ] false config) "noctalia";
          };
        };
      };
  };
}
