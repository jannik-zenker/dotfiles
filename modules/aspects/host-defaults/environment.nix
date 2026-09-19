{ lib, ... }: {
  den.aspects.environment.homeManager =
    { config, ... }:
    let
      cfg = config.defaultApps;
    in
    {
      # Not every host/user declares every category, so missing ones are
      # skipped instead of failing eval; the env var name is just the
      # defaultApps category name uppercased.
      home.sessionVariables = lib.listToAttrs (
        map (name: lib.nameValuePair (lib.toUpper name) cfg.${name}.command) (
          lib.filter (name: builtins.hasAttr name cfg) [
            "browser"
            "editor"
            "terminal"
          ]
        )
      );
    };
}
