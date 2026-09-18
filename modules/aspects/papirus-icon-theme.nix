# Install papirus-icon-theme system-wide once, shared by any aspect that
# uses it as an icon theme (gtk, kde) without those aspects depending on
# each other.
{
  den.aspects.papirusIconTheme.provides.to-hosts.nixos = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.papirus-icon-theme ];
  };
}
