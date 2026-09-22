{
  den.aspects.modernCli.homeManager = { pkgs, ... }: {
    programs = {
      bat = {
        enable = true;
        config.style = "plain";
      };

      eza = {
        enable = true;
        enableZshIntegration = true;
        enableFishIntegration = true;
        enableNushellIntegration = false;
        enableBashIntegration = true;
        git = true;
        icons = "auto";
      };

      fd.enable = true;

      fzf = {
        enable = true;
        enableZshIntegration = true;
      };

      ripgrep.enable = true;

      zoxide = {
        enable = true;
        enableZshIntegration = true;
        # Replace the `cd` builtin itself with zoxide's frecency-based jump,
        # instead of zoxide's default separate `z`/`zi` commands.
        options = [ "--cmd cd" ];
      };

    };

    home.packages = with pkgs; [
      duf
      dust
    ];

    home.shellAliases = {
      cat = "bat";
    };
  };
}
