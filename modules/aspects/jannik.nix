{ den, ... }:
{
  # user aspect
  den.aspects.jannik = {
    includes = [
      den.batteries.primary-user
      (den.batteries.user-shell "zsh")
    ];
  };
}
