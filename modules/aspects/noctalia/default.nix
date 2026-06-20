{ inputs, lib, ... }:
{
  flake-file = {
    inputs = {
      noctalia = {
        url = "github:noctalia-dev/noctalia";
      };
    };
  };

  den.aspects.noctalia = { host, ... }: {
    provides.to-hosts.nixos = { pkgs, ... }: {
      # Enable binary cache for noctalia to avoid building from source
      nix.settings = {
        extra-substituters = [ "https://noctalia.cachix.org" ];
        extra-trusted-public-keys = [
          "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        ];
      };
      # Enable laptop services for power management
      services = {
        power-profiles-daemon.enable = host.profile == "laptop";
        upower.enable = host.profile == "laptop";
      };
      environment.systemPackages = lib.mkIf (host.profile == "desktop") [
        pkgs.ddcutil
      ];
    };

    homeManager = { pkgs, ... }: {
      imports = [ inputs.noctalia.homeModules.default ];

      # Install dependencies
      home.packages = with pkgs; [
        nerd-fonts.roboto-mono
        inter
      ];

      programs.noctalia = {
        enable = true;
        systemd.enable = true;
        settings = {
          audio = {
            enable_sounds = true;
            sound_volume = 0.84999998100101948;
          };

          bar.default = {
            end = [
              "media"
              "tray"
              "network"
              "bluetooth"
              "volume"
              "battery"
              "notifications"
            ];
            margin_ends = 300;
            scale = 1.1000000089406967;
            start = [
              "control-center"
              "brightness"
              "workspaces"
            ];
            thickness = 35;
          };

          calendar.enabled = true;

          control_center = {
            sidebar_section = "none";
            shortcuts = [
              { type = "caffeine"; }
              { type = "nightlight"; }
              { type = "notification"; }
              { type = "power_profile"; }
            ];
          };

          desktop_widgets = {
            schema_version = 2;
            widget_order = [ ];
            grid = {
              cell_size = 16;
              major_interval = 4;
              visible = true;
            };
            widget = { };
          };

          dock.enabled = false;

          idle = {
            behavior_order = [
              "screen-off"
              "lock"
              "lock-and-suspend"
            ];
            pre_action_fade_seconds = 15;
            behavior = {
              lock = {
                action = "lock";
                enabled = true;
                timeout = 320;
              };
              "lock-and-suspend" = {
                action = "lock_and_suspend";
                enabled = true;
                timeout = 900;
              };
              "screen-off" = {
                action = "screen_off";
                enabled = true;
                timeout = 300;
              };
            };
          };

          location.auto_locate = true;

          lockscreen.tint_intensity = 0.4999999888241291;

          lockscreen_widgets = {
            enabled = true;
            schema_version = 2;
            widget_order = [ ];
            grid = {
              cell_size = 16;
              major_interval = 4;
              visible = true;
            };
          };

          nightlight = {
            enabled = true;
            temperature_night = 3000;
          };

          notification.layer = "overlay";

          osd = {
            offset_y = 30;
            position = "bottom_center";
            scale = 1.1499999999999999;
          };

          plugins.enabled = [ "noctalia/timer" ];

          shell = {
            corner_radius_scale = 2.0;
            font_family = "Inter";
            launch_apps_as_systemd_services = true;
            settings_show_advanced = true;
            animation.speed = 0.90000000000000002;
            panel = {
              borders = false;
              launcher_categories = false;
              open_near_click_control_center = true;
              transparency_mode = "soft";
              wallpaper_placement = "centered";
            };
            screenshot = {
              copy_to_clipboard = false;
              freeze_screen = false;
              save_to_file = false;
            };
          };

          system.monitor.enabled = false;

          theme = {
            community_palette = "Oxocarbon";
            mode = "dark";
            source = "wallpaper";
            templates = {
              builtin_ids = [
                "btop"
                "cava"
                "gtk3"
                "gtk4"
                "ghostty"
                "helix"
                "qt"
              ];
              community_ids = [
                "discord"
                "papirus-icons"
                "pywalfox"
                "steam"
              ];
            };
          };

          wallpaper = {
            directory = "~/Pictures/Wallpapers";
            transition = [ "zoom" ];
            transition_on_startup = true;
            default.path = "/home/jannik/Pictures/Wallpapers/lofi_cozy_room.png";
          };

          widget = {
            battery.show_label = false;
            brightness.show_label = false;
            control-center.glyph = "snowflake";
            media = {
              hide_when_no_media = true;
              title_scroll = "on_hover";
            };
            network.show_label = false;
            workspaces.font_family = "RobotoMono Nerd Font Propo";
          };
        };
      };
    };
  };
}
