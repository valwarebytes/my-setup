{
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    waybar
    inotify-tools
    pavucontrol
    pamixer
  ];

  hjem.users.val.xdg.config.files = {
    "waybar/launch-waybar.sh".source =
      pkgs.writeShellScript "launch-waybar.sh"
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

        modules-left = ["hyprland/workspaces"];
        modules-center = ["clock"];
        modules-right = [
          "temperature"
          "cpu"
          "memory"
          "disk"
          "network"
          "backlight"
          "pulseaudio"
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
          format = " {:%a %d %b  %H:%M}";
          tooltip-format = "<big>{:%B %Y}</big>\n<tt><small>{calendar}</small></tt>";
        };

        temperature = {
          # adjust hwmon-path if needed: ls /sys/class/hwmon/*/temp*_input
          critical-threshold = 80;
          interval = 5;
          format = "{icon} {temperatureC}°C";
          format-icons = ["" "" "" "" ""];
          # states so CSS can color it
          tooltip = true;
        };

        cpu = {
          interval = 5;
          format = " {usage:2}%";
          tooltip = true;
          # shows per-core on hover
          format-multiline = false;
          states = {
            warning = 70;
            critical = 90;
          };
        };

        memory = {
          interval = 5;
          format = " {used:0.1f}G/{total:0.1f}G";
          tooltip-format = "RAM: {used:0.1f}GiB used\nSwap: {swapUsed:0.1f}GiB used";
          states = {
            warning = 70;
            critical = 90;
          };
        };

        disk = {
          interval = 30;
          format = "󰋊 {percentage_used}%";
          tooltip-format = "{used} / {total} used on {path}";
          path = "/";
          states = {
            warning = 75;
            critical = 90;
          };
        };

        network = {
          interval = 5;
          format-wifi = "󰤨 {essid} {signalStrength}%";
          format-ethernet = "󰈀 {ipaddr}";
          format-disconnected = "󰤭 disconnected";
          tooltip-format-wifi = "SSID: {essid}\nSignal: {signalStrength}%\n↓ {bandwidthDownBits}  ↑ {bandwidthUpBits}";
          tooltip-format-ethernet = "Interface: {ifname}\nIP: {ipaddr}/{cidr}\n↓ {bandwidthDownBits}  ↑ {bandwidthUpBits}";
          on-click = "nm-connection-editor";
        };

        backlight = {
          device = "intel_backlight";
          format = "{icon} {percent}%";
          format-icons = ["󰃞" "󰃟" "󰃠"];
          tooltip = false;
        };

        pulseaudio = {
          format = "{icon} {volume:2}%";
          format-bluetooth = "󰂯 {volume}%";
          format-muted = "󰝟 muted";
          format-icons = {
            headphones = "󰋋";
            headset = "󰋎";
            default = ["󰕿" "󰖀" "󰕾"];
          };
          scroll-step = 5;
          on-click = "pamixer -t";
          on-click-right = "pavucontrol";
          tooltip-format = "{desc}\n{volume}%";
        };

        battery = {
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󰚥 {capacity}%";
          format-full = "󰁹 full";
          format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
          tooltip-format = "{timeTo}\n{power:.1f}W";
        };

        tray = {
          icon-size = 18;
          spacing = 6;
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
            font-size: 13px;
            font-family: "monospace", "JetBrainsMono Nerd Font", "Symbols Nerd Font";
            min-height: 0;
            margin: 0;
        }

        window#waybar {
            background: #111111;
            color: #dddddd;
        }

        /* ── Workspaces ─────────────────────────────── */

        #workspaces {
            padding-left: 4px;
        }

        #workspaces button {
            padding: 0 8px;
            background: #2a2a2a;
            color: #888888;
            min-width: 12px;
            margin: 3px 2px;
            border-radius: 3px;
        }

        #workspaces button:hover {
            background: #333333;
            color: #dddddd;
        }

        #workspaces button.active {
            background: #dada3a;
            color: #111111;
            font-weight: bold;
        }

        #workspaces button.urgent {
            background: #cc3333;
            color: #ffffff;
        }

        /* ── Center clock ───────────────────────────── */

        #clock {
            color: #dddddd;
            padding: 0 10px;
        }

        /* ── Right modules base ─────────────────────── */

        #temperature,
        #cpu,
        #memory,
        #disk,
        #network,
        #backlight,
        #pulseaudio,
        #battery,
        #tray {
            padding: 0 8px;
            color: #aaaaaa;
        }

        /* Subtle separator between right modules */
        #temperature,
        #cpu,
        #memory,
        #disk,
        #network,
        #backlight,
        #pulseaudio,
        #battery {
            border-left: 1px solid #2a2a2a;
        }

        /* ── Warning / critical states ──────────────── */

        #cpu.warning,
        #memory.warning,
        #disk.warning,
        #temperature.critical {
            color: #e0a040;
        }

        #cpu.critical,
        #memory.critical,
        #disk.critical {
            color: #cc3333;
        }

        /* ── Battery ────────────────────────────────── */

        #battery.good {
            color: #77aa77;
        }

        #battery.warning {
            color: #e0a040;
        }

        #battery.critical {
            color: #cc3333;
            animation: blink 1s linear infinite;
        }

        #battery.charging {
            color: #77aa77;
        }

        /* ── Network ────────────────────────────────── */

        #network.disconnected {
            color: #666666;
        }

        /* ── Blink animation for critical battery ───── */

        @keyframes blink {
            to { color: #ffffff; }
        }
      '';
  };
}
