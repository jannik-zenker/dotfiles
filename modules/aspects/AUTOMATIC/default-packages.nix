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
      ++ lib.optionals (host.profile == "server") [
        tmux
        smartmontools
      ];
  };
}
