# Each `den.hosts.<system>.<name>` entry becomes a `nixosConfigurations.<name>`
# flake output, and each `users.<name>` becomes its own entity whose aspect
# is resolved by matching name (e.g. `users.jannik` pulls in
# `den.aspects.jannik`). `lumiere` (the server) uses the separate
# `admin-jannik` user aspect instead of `jannik` since it only needs a shell
# and SSH access, not the desktop-oriented aspects (niri, firefox, ...) the
# other hosts' `jannik` user includes.
{
  den.hosts.x86_64-linux.hauler = {
    bootloader = "grub";
    cpu = "amd";
    gpu = "amd";
    profile = "laptop";

    users.jannik = {
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
      gitName = "Jannik Zenker";
      gitMail = "accounts@jannikzenker.de";
    };
  };
}
