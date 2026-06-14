{ den, ... }:
{
  # user aspect
  den.aspects.jannik = {
    includes = [
      den.aspects.fonts
      den.aspects.ghostty
      den.aspects.helix
      den.aspects.modernCli
      den.aspects.niri
      den.aspects.noctalia
      den.aspects.starship
      den.aspects.zsh
      den.aspects.zenBrowser
      den.batteries.primary-user
      (den.batteries.user-shell "zsh")
    ];
  };
}
