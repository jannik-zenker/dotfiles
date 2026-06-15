{ lib, ... }:
{
  den.aspects.cava = {
    homeManager = { config, ... }: {
      programs.cava = {
        enable = true;
        settings = {
          theme = lib.mkIf (lib.attrByPath [ "programs" "noctalia" "enable" ] false config) "noctalia";
        };
      };
    };
  };
}
