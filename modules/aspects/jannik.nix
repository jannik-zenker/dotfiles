{ den, ... }: {
  # Full desktop-user aspect: composes every app/tool aspect this user wants
  # on desktop/laptop hosts, plus the batteries that turn it into a real
  # primary user with a login shell.
  den.aspects.jannik = {
    includes = [
      den.aspects.alacritty
      den.aspects.bitwardenDesktop
      den.aspects.cava
      den.aspects.claudeCode
      den.aspects.dolphin
      den.aspects.firefox
      den.aspects.git
      den.aspects.gtk
      den.aspects.gwenview
      den.aspects.kde
      den.aspects.modernCli
      den.aspects.mpv
      den.aspects.neovim
      den.aspects.nextcloudClient
      den.aspects.obsidian
      den.aspects.office
      den.aspects.okular
      den.aspects.spotify
      den.aspects.sshAgent
      den.aspects.starship
      den.aspects.vesktop
      den.aspects.zsh
      den.batteries.primary-user
      (den.batteries.user-shell "zsh")
    ];
  };
}
