{
  den.aspects.texlive = {
    nixos = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [ texliveFull ];
    };

    provides.to-users.homeManager = { config, ... }: {
      home.sessionVariables = {
        TEXMFHOME = "${config.xdg.dataHome or "$HOME/.local/share"}/texmf";
        TEXMFVAR = "${config.xdg.cacheHome or "$HOME/.cache"}/texmf";
        TEXMFCONFIG = "${config.xdg.configHome or "$HOME/.config"}/texmf";
      };
    };
  };
}
