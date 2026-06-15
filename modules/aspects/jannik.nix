{ den, ... }:
{
  # user aspect
  den.aspects.jannik = {
    includes = [
      den.aspects.dolphin
      den.aspects.fonts
      den.aspects.ghostty
      den.aspects.gtk
      den.aspects.helix
      den.aspects.modernCli
      den.aspects.niri
      den.aspects.noctalia
      den.aspects.papirusIconTheme
      den.aspects.qt
      den.aspects.starship
      den.aspects.zsh
      den.aspects.zenBrowser
      den.batteries.primary-user
      (den.batteries.user-shell "zsh")
    ];
  };
}
