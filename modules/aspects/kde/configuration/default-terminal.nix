{
  # Dolphin's "Open Terminal Here" (and other Plasma terminal launches) don't
  # go through xdg.mimeApps/xdg-terminal-exec: terminals have no MIME type,
  # so KDE reads its own TerminalApplication/TerminalService keys from
  # kdeglobals instead. Without this, Dolphin falls back to Konsole, which
  # this setup excludes from the system.
  den.aspects.kde.homeManager = { config, ... }: {
    programs.plasma.configFile.kdeglobals."General" = {
      TerminalApplication = config.defaultApps.terminal.command;
      TerminalService = config.defaultApps.terminal.desktopFile;
    };
  };
}
