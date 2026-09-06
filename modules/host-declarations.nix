{ inputs, ... }:
{
  den.hosts.x86_64-linux.hauler = {
    bootloader = "grub";
    cpu = "amd";
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

  den.hosts.x86_64-linux.lumiere = {
    bootloader = "systemd-boot";
    cpu = "amd";
    gpu = "amd";
    profile = "server";

    users.admin-jannik = { };
  };

  den.hosts.x86_64-linux.reacher = {
    bootloader = "grub";
    cpu = "intel";
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
    cpu = "intel";
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
