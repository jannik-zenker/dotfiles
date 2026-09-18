{ den, ... }: {
  # user aspect
  den.aspects.jannik = {
    includes = [
      den.aspects.bitwardenDesktop
      den.aspects.cava
      den.aspects.claudeCode
      den.aspects.desktopTools
      den.aspects.alacritty
      den.aspects.git
      den.aspects.gtk
      den.aspects.kde
      den.aspects.modernCli
      den.aspects.neovim
      den.aspects.nextcloudClient
      den.aspects.obsidian
      den.aspects.office
      den.aspects.starship
      den.aspects.vesktop
      den.aspects.zenBrowser
      den.aspects.zsh
      den.batteries.primary-user
      (den.batteries.user-shell "zsh")
    ];
  };
}
