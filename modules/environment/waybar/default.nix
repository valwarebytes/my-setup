{
  lib,
  pkgs,
  ...
}: {
  hjem.users.val.xdg.config.files = {
    "waybar/launch-waybar.sh".source =
      pkgs.writeShellScript "launch-waybar.sh"
      ''
        CONFIG_FILES="/home/val/.config/waybar"
        trap "pkill waybar" EXIT
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
        layer = "top"; # was "bottom" — windows would render over the bar
        position = "bottom";
        height = 34; # explicit height prevents inconsistent sizing across reloads

        modules-left = ["hyprland/workspaces"];
        modules-center = ["hyprland/window" "clock"];
        modules-right = [
          "idle_inhibitor"
          "temperature"
          "cpu"
          "memory"
          "disk"
          "network"
          "backlight"
          "pulseaudio"
          "battery"
          "tray"
          "custom/power"
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

        "hyprland/window" = {
          format = "{}";
          separate-outputs = true;
        };

        clock = {
          format = " {:%a %d %b  %H:%M}";
          tooltip-format = "<big>{:%B %Y}</big>\n<tt><small>{calendar}</small></tt>";
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "󰒳";
            deactivated = "󰒲";
          };
          tooltip-format-activated = "Idle inhibitor: ON";
          tooltip-format-deactivated = "Idle inhibitor: OFF";
        };

        temperature = {
          hwmon-path = "/sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon4/temp1_input";
          critical-threshold = 80;
          interval = 5;
          format = "{icon} {temperatureC}°C";
          format-icons = ["" "" "" "" ""];
          tooltip = true;
        };

        cpu = {
          interval = 5;
          format = " {usage:2}%";
          tooltip = true;
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
          device = "amdgpu_bl1";
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

        "custom/power" = {
          format = "⏻";
          tooltip = false;
          on-click = "wlogout";
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
            /* Fixed: JetBrainsMono first so the nerd font is actually used,
               "monospace" is now the generic fallback */
            font-family: "JetBrainsMono Nerd Font", "Symbols Nerd Font", monospace;
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
            background: #58e1ff;
            color: #111111;
            font-weight: bold;
        }

        #workspaces button.urgent {
            background: #cc3333;
            color: #ffffff;
        }

        /* ── Center ─────────────────────────────────── */

        #clock,
        #window {
            color: #dddddd;
            padding: 0 10px;
        }

        #window {
            color: #888888;
            font-style: italic;
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
        #idle-inhibitor,
        #custom-power,
        #tray {
            padding: 0 8px;
            color: #aaaaaa;
            /* Smooth color transitions between normal/warning/critical states */
            transition: color 0.3s ease;
        }

        /* Subtle separator between right modules */
        #temperature,
        #cpu,
        #memory,
        #disk,
        #network,
        #backlight,
        #pulseaudio,
        #battery,
        #idle-inhibitor {
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

        /* ── Idle inhibitor ─────────────────────────── */

        #idle-inhibitor.activated {
            color: #dada3a;
        }

        /* ── Power button ───────────────────────────── */

        #custom-power {
            color: #666666;
            padding: 0 10px;
        }

        #custom-power:hover {
            color: #cc3333;
        }

        /* ── Blink animation for critical battery ───── */

        @keyframes blink {
            from { color: #cc3333; } /* explicit from state added */
            to   { color: #ffffff; }
        }
      '';
  };
}
