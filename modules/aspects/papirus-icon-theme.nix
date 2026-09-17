# Install papirus-icon-theme
{
  den.aspects.papirusIconTheme = {
    nixos = { pkgs, ... }: { environment.systemPackages = with pkgs; [ papirus-icon-theme ]; };

    homeManager = { pkgs, ... }: { home.packages = with pkgs; [ papirus-icon-theme ]; };
  };
}
