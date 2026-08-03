{ den, ... }:
{
  # user aspect
  den.aspects.admin-jannik = {
    includes = [
      den.aspects.starship
      den.aspects.zsh
      den.batteries.primary-user
      (den.batteries.user-shell "zsh")
    ];

    nixos = {
      users.users.admin-jannik.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOrMujlvICa7sJv9zY8HhOdd+YyZwttibJ3LtJsv+eH9 jannik@reacher"
      ];
    };
  };
}
