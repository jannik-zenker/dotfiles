{
  den.aspects.kde = {
    nixos = { pkgs, ... }: {
      services.desktopManager.plasma6.enable = true;
      environment.plasma6.excludePackages = with pkgs.kdePackages; [
        plasma-browser-integration # Browser-/Plasma-Integration
        plasma-workspace-wallpapers # KDE-Standardwallpaper
        konsole # Terminal
        kwin-x11 # X11-KWin
        qttools # Qt-Entwicklungswerkzeuge

        elisa # Musikplayer
        gwenview # Bildbetrachter
        okular # PDF-/Dokumentviewer
        kate # Texteditor
        ktexteditor # Kate/KDE-Texteditor-Framework
        khelpcenter # KDE-Hilfe

        spectacle # Screenshots/Screen Recording
        krdp # Remote Desktop

        plasma-keyboard # Bildschirmtastatur
        qtvirtualkeyboard # Qt-Bildschirmtastatur

        union # Plasma-Hilfstool
        qrca # QR-Code-App
        qtsensors # Sensor-Unterstützung
        discover # Software-Center
      ];
    };

    homeManager = {

    };
  };
}
