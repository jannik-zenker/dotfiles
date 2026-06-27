{
  den.aspects.zedEditor = {
    homeManager = { pkgs, ... }: {
      programs.zed-editor = {
        enable = true;
        defaultEditor = true;
        extraPackages = with pkgs; [
          nerd-fonts.monaspace
          nixd
          nixfmt
          texlab
        ];
      };
    };
  };
}
