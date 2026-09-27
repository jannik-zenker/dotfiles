{
  den.aspects.gaming.nixos = { pkgs, ... }: {
    programs.steam = {
      enable = true;
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
    };

    # Create group "gaming" for multi-user access to game drives
    users.groups.gaming = { };

    environment.systemPackages = with pkgs; [
      heroic
      faugus-launcher
      lutris
      prismlauncher
    ];
  };
}
