{
  den.aspects.kde.homeManager = {
    programs.plasma.window-rules = [
      {
        description = "Work applications";

        match.window-class = {
          value = "slack|teams-for-linux";
          type = "regex";
        };

        apply.desktops = {
          value = "Desktop_2";
          apply = "initially";
        };
      }

      {
        description = "Gaming applications";

        match.window-class = {
          value = "steam|prismlauncher|heroic|lutris|faugus";
          type = "regex";
        };

        apply.desktops = {
          value = "Desktop_3";
          apply = "initially";
        };
      }

      {
        description = "Spotify";

        match.window-class = {
          value = "spotify";
          type = "substring";
        };

        apply.desktops = {
          value = "Desktop_4";
          apply = "initially";
        };
      }
    ];
  };
}
