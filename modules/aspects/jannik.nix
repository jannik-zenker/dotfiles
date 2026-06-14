{ den, ... }:
{
  # user aspect
  den.aspects.jannik = {
    includes = [
      den.aspects.fonts
      den.aspects.ghostty
      den.aspects.modernCli
      den.aspects.niri
      den.aspects.starship
      den.aspects.zsh
      den.batteries.primary-user
      (den.batteries.user-shell "zsh")
    ];
  };
}
