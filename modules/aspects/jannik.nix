{ den, ... }:
{
  # user aspect
  den.aspects.jannik = {
    includes = [
      den.aspects.bitwardenDesktop
      den.aspects.cava
      den.aspects.desktopTools
      den.aspects.fonts
      den.aspects.ghostty
      den.aspects.git
      den.aspects.gtk
      den.aspects.helix
      den.aspects.modernCli
      den.aspects.nemo
      den.aspects.nextcloudClient
      den.aspects.niri
      den.aspects.noctalia
      den.aspects.office
      den.aspects.pywalfox
      den.aspects.qt
      den.aspects.starship
      den.aspects.thunderbird
      den.aspects.vesktop
      den.aspects.zsh
      den.aspects.zenBrowser
      den.batteries.primary-user
      (den.batteries.user-shell "zsh")
    ];
  };
}
