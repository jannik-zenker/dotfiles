{ lib, ... }: {
  den.aspects.defaultPackages.nixos = { host, pkgs, ... }: {
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
      # Nicer interactive rebuild output/diffing, only useful where a human
      # watches rebuilds.
      ++
        lib.optionals
          (builtins.elem host.profile [
            "desktop"
            "laptop"
          ])
          [
            nh
            nix-output-monitor
            nvd
          ]
      # tmux for sessions that survive an SSH disconnect; smartmontools for
      # disk health monitoring on long-running storage.
      ++ lib.optionals (host.profile == "server") [
        tmux
        smartmontools
      ];
  };
}
