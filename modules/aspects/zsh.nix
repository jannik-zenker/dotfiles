{ den, ... }:
{
  den.aspects.zsh = {
    includes = [ den.aspects.fzf ];

    homeManager = { pkgs, ... }: {
      programs.zsh = {
        enable = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        plugins = [
          {
            name = "fzf-tab";
            src = pkgs.zsh-fzf-tab;
            file = "share/fzf-tab/fzf-tab.plugin.zsh";
          }
          {
            name = "sudo";
            src = pkgs.oh-my-zsh;
            file = "share/oh-my-zsh/plugins/sudo/sudo.plugin.zsh";
          }
        ];
      };
    };
  };
}
