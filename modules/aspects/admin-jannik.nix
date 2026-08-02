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
  };
}
