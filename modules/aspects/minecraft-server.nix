{ inputs, ... }: {
  flake-file.inputs.nix-minecraft = {
    url = "github:Infinidoge/nix-minecraft";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.minecraftServer.nixos =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      serverName = "fsr";
      dataDir = "/var/lib/minecraft";
      unit = "minecraft-server-${serverName}.service";
      tmux = "${lib.getExe pkgs.tmux} -S ${
        config.services.minecraft-servers.servers.${serverName}.managementSystem.tmux.socketPath serverName
      }";

      saveOff = pkgs.writeShellScript "minecraft-save-off" ''
        set -euo pipefail
        systemctl is-active --quiet ${unit} || exit 0

        log=${dataDir}/${serverName}/logs/latest.log
        seen=$(grep -c "Saved the game" "$log" || true)

        ${tmux} send-keys C-u "save-off" Enter
        ${tmux} send-keys C-u "save-all flush" Enter

        # save-all is asynchronous from our side; wait for the server to log
        # that the flush finished so the snapshot sees a consistent world.
        for _ in $(seq 120); do
          [ "$(grep -c "Saved the game" "$log" || true)" -gt "$seen" ] && exit 0
          sleep 1
        done
        echo "timed out waiting for save-all flush" >&2
        exit 1
      '';

      saveOn = pkgs.writeShellScript "minecraft-save-on" ''
        systemctl is-active --quiet ${unit} || exit 0
        ${tmux} send-keys C-u "save-on" Enter
      '';

      plugins = {
        "plugins/GriefPrevention.jar" = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/O4o4mKaq/versions/dGfCZHqk/GriefPrevention.jar";
          sha512 = "c9bc692253ba3860327e5c38767ce3dc66c798264fe650a08b4ae888337ff75bc16e9bd1db7b39a514a275bf2cc2a3f1f8cd95cf080b89ae42a0f684fc2bfc66";
        };

        "plugins/CoreProtect.jar" = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/Lu3KuzdV/versions/3sehX6Sg/CoreProtect-CE-24.1.jar";
          sha512 = "76aad727528ddb990bbee5069f8ef3fcd018ae0bcdea89b965be2485e828633eb068672e841be64e550c8474f901a24d8c15c7bd44c2bd6c96244e1e58de0c95";
        };

        "plugins/LuckPerms.jar" = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/Vebnzrzj/versions/b0mk8uS6/LuckPerms-Bukkit-5.5.71.jar";
          sha512 = "188a91f0a543d23bfda32385fca6db63d61e49c8a422bd452a260bd9cbc6a7d7fe45071199e9fca8f3ce43c2b41ee84fd315bd15464577028ff3951a7d4fab27";
        };

        "plugins/Chunky.jar" = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/fALzjamp/versions/MdY6JATr/Chunky-Bukkit-1.5.3.jar";
          sha512 = "43ffecc6e6a734b752da41575bbb316526c124c3f878942437d5133c377bfbd9b78bda975520dc074d7158c15dade58a444ccd0fd8d8a25d165b6fc450140422";
        };

        "plugins/EssentialsX.jar" = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/hXiIvTyT/versions/nY6VN1XH/EssentialsX-2.22.0.jar";
          sha512 = "472ecf71924801723643ca6e1f9931297de5aa0874a544f8a719e2e2f7c81af81ef7bcbd38b6e43f0260a9dae6abe42c97907e70e2430e326ff8cff12ebd61cf";
        };

        "plugins/Bluemap.jar" = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/swbUV1cr/versions/pILlMIlN/bluemap-5.28-paper.jar";
          sha512 = "f831c8a8609cf37a16b31bc14330d6de190f149587c005b15d06452c8ae3f36b3e0a169919899fcc0bdcdb9fbfbca2b4a7d06fa884ed06884be802a557c12201";
        };
      };
    in
    {
      imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
      nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

      # Pause world saving around backup-local so the btrbk snapshot never
      # catches half-written region files. Only applies on hosts with btrbk.
      # ExecStopPost also runs when the pre-hook or the backup fails, so
      # saving is always switched back on.
      systemd.services.backup-local = lib.mkIf (config.services.btrbk.instances ? local) {
        serviceConfig = {
          ExecStartPre = [ saveOff ];
          ExecStopPost = [ saveOn ];
        };
      };

      services.minecraft-servers = {
        enable = true;
        eula = true;
        openFirewall = true;
        inherit dataDir;
        servers.${serverName} = {
          enable = true;
          autoStart = true;

          package = pkgs.paperServers.paper-26_1_2;

          symlinks = plugins;

          jvmOpts = "-Xms4G -Xmx6G";

          serverProperties = {
            server-port = 25565;

            level-seed = "-451079695398258179";
            level-name = "world";

            motd = "Server der Fachschaft Physik - UDS";
            max-players = 30;

            gamemode = "survival";
            difficulty = "normal";

            white-list = true;
            enforce-whitelist = true;

            online-mode = true;
            pvp = true;

            view-distance = 8;
            simulation-distance = 6;
          };
        };
      };
    };
}
