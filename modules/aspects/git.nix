{ lib, ... }:
{
  den.aspects.git = { user, ... }: {
    nixos = {
      programs.git = {
        enable = true;
        config.defaultBranch = "main";
      };
    };

    provides.to-users.homeManager = {
      programs.git = {
        enable = true;
        settings.user = {
          name = lib.mkIf (user.gitName != null) user.gitName;
          email = lib.mkIf (user.gitMail != null) user.gitMail;
        };
      };
    };
  };
}
