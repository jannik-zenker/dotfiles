{
  den.aspects.vesktop = {
    homeManager = {
      programs.vesktop = {
        enable = true;
        vencord.settings = {
          enabledThemes = [ "noctalia-material.theme.css" ];
          plugins = {
            FakeNitro.enabled = true;
          };
        };
      };
    };
  };
}
