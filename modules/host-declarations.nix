{
  den.hosts.x86_64-linux.hauler = {
    bootloader = "systemd-boot";
    gpu = "amd";
    profile = "desktop";

    users.jannik = {
      defaultBrowser = "zen-beta";
      defaultTerminal = "ghostty";
      gitName = "Jannik Zenker";
      gitMail = "accounts@jannikzenker.de";
    };
  };
}
