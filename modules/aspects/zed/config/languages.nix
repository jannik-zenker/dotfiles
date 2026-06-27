{
  den.aspects.zedEditor = {
    homeManager = {
      programs.zed-editor.userSettings = {
        #--- Nix ---#
        languages.Nix = {
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
