{ den, ... }: {
  # Minimal admin user for headless hosts (see lumiere.nix): shell + SSH
  # access only, unlike jannik.nix's full desktop-user aspect.
  den.aspects.admin-jannik = {
    includes = [
      den.aspects.starship
      den.aspects.zsh
      den.batteries.primary-user
      (den.batteries.user-shell "zsh")
    ];

    nixos = {
      # Trust jannik's own SSH keys from the other hosts, so remote admin
      # access works without any further per-host provisioning.
      users.users.admin-jannik.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOrMujlvICa7sJv9zY8HhOdd+YyZwttibJ3LtJsv+eH9 jannik@reacher"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICGjnLVxIAjADjDt6nLiGaAQvx9YPfEFpMCigWrwIwFP jannik@hauler"
      ];
    };
  };
}
