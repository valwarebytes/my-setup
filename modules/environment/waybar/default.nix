{
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    waybar
  ];
  hjem.users.val.xdg.config.files = {
    "waybar/launch-waybar.sh".source =
      pkgs.writeShellScript "launch-waybar.sh"
      /*
      sh
      */
      ''
        CONFIG_FILES="/home/val/.config/waybar"

        trap "killall waybar" EXIT

        while true; do
          waybar &
          export APP_PID=$!
          ${pkgs.inotify-tools}/bin/inotifywait -e create,modify $CONFIG_FILES
          kill $APP_PID
        done
      '';
    "waybar/config.jsonc" = {
      generator = lib.generators.toJSON {};
      value = {
        layer = "bottom";
        position = "bottom";
        # margin = "10px";

        modules-left = ["hyprland/workspaces"];
        modules-center = ["clock"];
        modules-right = [
          "pulseaudio"
          "backlight"
          "memory"
          "cpu"
          "disk"
          "battery"
          "tray"
        ];

        "hyprland/workspaces" = {
          all-outputs = true;
          disable-scroll = true;
          persistent_workspaces = {
            "1" = [];
            "2" = [];
            "3" = [];
            "4" = [];
            "5" = [];
            "6" = [];
            "7" = [];
            "8" = [];
            "9" = [];
            "10" = [];
          };
        };

        clock = {
          format = "{:%a %d %b, %H:%M}";
          tooltip = false;
        };

        pulseaudio = {
          format = "{icon} {volume:2}%";
          format-bluetooth = "{icon} {volume}%  ";
          format-muted = "muted";

          format-icons = {
            headphones = ''O/-v-\O'';
            default = [
              "-u- "
              "OnO"
            ];
          };
          scroll-step = 5;
          on-click = "pamixer -t";
          on-click-right = "pavucontrol";
        };

        memory = {
          interval = 5;
          format = "Mem {}%";
        };

        cpu = {
          interval = 5;
          format = "CPU {usage:2}%";
        };

        backlight = {
          device = "intel_backlight";
          format = "{icon} {percent}%";
          format-icons = [
            "-w-"
            ";w;"
          ];
        };

        battery = {
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          format = "BAT {icon} {capacity}%";
          format-icons = [
            "[----]"
            "[#---]"
            "[##--]"
            "[###-]"
            "[####]"
          ];
        };

        disk = {
          interval = 5;
          format = "DISK {percentage_used:2}%";
          path = "/";
        };

        tray = {
          icon-size = 18;
        };
      };
    };
    "waybar/style.css".text =
      /*
      css
      */
      ''
        * {
            border: none;
            border-radius: 0;
            font-size: 14px;
            font-family: "monospace";
            min-height: 0;
            margin: 0px;
        }

        window#waybar {
            background: #111111;
        }

        #workspaces {
            padding-left: 2px;
        }

        #workspaces button {
            padding: 0 8 0 8;
            background: #aaaaaa;
            color: #000000;
            min-width: 10px;
            margin: 2px;
        }

        #workspaces button.active{
            background: #dada3a;
        }

        #pulseaudio,
        #memory,
        #cpu,
        #battery,
        #disk {
          padding: 0 5px;
        }

      '';
  };
}
