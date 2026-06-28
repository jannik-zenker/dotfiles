{
  den.aspects.zedEditor = {
    homeManager = {
      programs.zed-editor.userSettings = {
        #--- Nix ---#
        languages.Nix = {
        tab_size = 2;
        language_servers = [
            "nixd"
            "!nil"
          ];

          formatter.external = {
            command = "nixfmt";
            arguments = [
              "--quiet"
              "--"
            ];
          };
        };
      };
    };
  };
}
