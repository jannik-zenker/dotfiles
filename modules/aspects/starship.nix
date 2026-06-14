{
  den.aspects.starship = {
    homeManager = {
      programs.starship = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableNushellIntegration = true;
        enableZshIntegration = true;

        settings = {
          format = "$directory$character";
          right_format = "$git_branch$git_status$git_state$python$nodejs$rust";

          directory = {
            format = "[$path](cyan) ";
            truncation_length = 3;
          };

          git_branch = {
            style = "yellow";
            format = "[$symbol $branch]($style) ";
            symbol = " ";
          };

          git_status = {
            style = "yellow";
            format = "[$modified$deleted$untracked$ahead_behind]($style)";
            modified = " ";
            deleted = " ";
            untracked = " ";
            ahead = " ";
            behind = " ";
            up_to_date = "[ ](green)";
          };

          python.format = "[🐍](bright-green) ";
          nodejs.format = "[⬢](bright-green) ";
          rust.format = "[🦀](bright-green) ";

          character = {
            success_symbol = "[❯](green) ";
            error_symbol = "[❯](red) ";
          };
        };
      };
    };
  };
}
