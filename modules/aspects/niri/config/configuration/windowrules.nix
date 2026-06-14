{
  den.aspects.niri = {
    homeManager = {
      xdg.configFile."niri/configuration/windowrules.kdl".text = ''
        // Open on workspace: browser
        window-rule {
            open-on-workspace "browser"
            match app-id="librewolf"
        }
        // Open on workspace: chat
        window-rule {
            open-on-workspace "chat"
            match app-id="slack"
            match app-id="teams-for-linux"
            match app-id="vesktop"
        }
        // Open on workspace: gaming
        window-rule {
            open-on-workspace "gaming"
            match app-id="heroic"
            match app-id="org.prismlauncher.PrismLauncher"
            match app-id="steam"
        }
        // Open on workspace: mail
        window-rule {
            open-on-workspace "mail"
            match app-id="org.mozilla.Thunderbird"
            match app-id="eu.betterbird.Betterbird"
        }
        // Open on workspace: music
        window-rule {
            open-on-workspace "music"
            match app-id="com.github.th_ch.youtube_music"
        }
        // Nemo floating
        window-rule {
            open-floating true
            default-column-width { fixed 1150; }
            default-window-height { fixed 765; }
            match app-id="nemo"
        }
        // Steam friends list floating
        window-rule {
            open-floating true
            default-column-width { fixed 500; }
            default-window-height { fixed 800; }
            match app-id="steam" title="Friends List"
        }
      '';
    };
  };
}
