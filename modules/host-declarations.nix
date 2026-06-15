{
  den.hosts.x86_64-linux.hauler = {
    bootloader = "systemd-boot";
    gpu = "amd";
    profile = "laptop";

    users.jannik = {
      defaultBrowser = "zen-beta";
      defaultFileManager = "nemo";
      defaultTerminal = "ghostty";
      gitName = "Jannik Zenker";
      gitMail = "accounts@jannikzenker.de";
    };
  };
}
