{
  den.hosts.x86_64-linux.hauler = {
    bootloader = "grub";
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

  den.hosts.x86_64-linux.reacher = {
    bootloader = "grub";
    gpu = "nvidia";
    profile = "desktop";

    users.jannik = {
      defaultBrowser = "zen-beta";
      defaultFileManager = "nemo";
      defaultTerminal = "ghostty";
      gitName = "Jannik Zenker";
      gitMail = "accounts@jannikzenker.de";
    };
  };

  den.hosts.x86_64-linux.sirene = {
    bootloader = "grub";
    gpu = "intel";
    profile = "desktop";

    users.jannik = {
      defaultBrowser = "zen-beta";
      defaultFileManager = "nemo";
      defaultTerminal = "ghostty";
      gitName = "Jannik Zenker";
      gitMail = "accounts@jannikzenker.de";
    };
  };
}
