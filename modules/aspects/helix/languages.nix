{
  den.aspects.helix = {
    homeManager = { pkgs, ... }: {
      programs.helix = {
        languages = {
          language-server.nixd = {
            command = "${pkgs.nixd}/bin/nixd";
          };

          language = [
            {
              name = "nix";
              language-servers = [ "nixd" ];
              formatter = {
                command = "${pkgs.nixfmt}/bin/nixfmt";
              };
              auto-format = true;
            }
          ];
        };
      };
    };
  };
}
