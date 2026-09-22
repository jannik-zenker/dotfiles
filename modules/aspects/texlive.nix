{
  den.aspects.texlive = {
    # System-wide rather than per-user (like most other app aspects), since
    # tools like neovim's texlab LSP need pdflatex/latexmk on PATH too, not
    # just an interactive shell.
    nixos = { pkgs, ... }: { environment.systemPackages = with pkgs; [ texliveFull ]; };

    # texlive.nixos is host-scoped, so this routes to users via
    # provides.to-users. Redirects TeX Live's local tree to XDG base dirs
    # instead of its traditional ~/.texmf, keeping $HOME uncluttered.
    provides.to-users.homeManager = { config, ... }: {
      home.sessionVariables = {
        TEXMFHOME = "${config.xdg.dataHome or "$HOME/.local/share"}/texmf";
        TEXMFVAR = "${config.xdg.cacheHome or "$HOME/.cache"}/texmf";
        TEXMFCONFIG = "${config.xdg.configHome or "$HOME/.config"}/texmf";
      };
    };
  };
}
