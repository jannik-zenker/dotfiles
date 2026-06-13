{ den, ... }:
{
  # user aspect
  den.aspects.jannik = {
    includes = [
      den.aspects.niri
      den.batteries.primary-user
      (den.batteries.user-shell "zsh")
    ];
  };
}
