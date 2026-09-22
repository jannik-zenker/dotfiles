{
  den.aspects.dolphin.homeManager = { pkgs, ... }: {
    defaultApps = {
      # Repo-defined, desktop-environment-agnostic option: wires this app
      # into the XDG default-app association for inode/directory
      # (host-defaults/xdg.nix), and is also read directly by KDE's
      # "open file manager" hotkey (kde/configuration/hotkeys.nix).
      fileManager = {
        command = "dolphin";
        desktopFile = "org.kde.dolphin.desktop";
      };

      # Wires this app into the XDG default-app associations for archive
      # mime types (host-defaults/xdg.nix).
      archiveManager = {
        command = "ark";
        desktopFile = "org.kde.ark.desktop";
      };
    };

    home.packages = with pkgs.kdePackages; [
      dolphin
      ark
    ];
  };
}
