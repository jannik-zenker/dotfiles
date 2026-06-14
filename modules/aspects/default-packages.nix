{ lib, ... }:
{
  den.aspects.defaultPackages = { host, ... }: {
    nixos = { pkgs, ... }: {
      environment.systemPackages =
        with pkgs;
        [
          btop
          curl
          dnsutils
          tree
          vim
          wget
        ]
        ++ lib.optionals (host.profile == "desktop") [
          bat
          nh
          nix-output-monitor
          nvd
          ripgrep
        ]
        ++ lib.optionals (host.profile == "server") [
          tmux
          smartmontools
        ];
    };
  };
}
