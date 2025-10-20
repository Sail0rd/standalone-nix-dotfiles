{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.playerctld.enable = true;
  home.packages = with pkgs; [
    playerctl
    jq
  ];

  programs.waybar =
    let
      # Dependencies
      jq = "${pkgs.jq}/bin/jq";
      systemctl = "${pkgs.systemd}/bin/systemctl";
      journalctl = "${pkgs.systemd}/bin/journalctl";
      pavucontrol = "${pkgs.pavucontrol}/bin/pavucontrol";
      rofi = "${pkgs.rofi}/bin/rofi";

      playerctl = "${pkgs.playerctl}/bin/playerctl";
      playerctld = "${pkgs.playerctl}/bin/playerctld";
      # terminal = "${pkgs.kitty}/bin/kitty";
      terminal = "${lib.getExe pkgs.alacritty}";
      terminal-spawn = cmd: "${terminal} $SHELL -i -c ${cmd}";
      jsonOutput =
        name:
        {
          pre ? "",
          text ? "",
          tooltip ? "",
          alt ? "",
          class ? "",
          percentage ? "",
        }:
        "${pkgs.writeShellScriptBin "waybar-${name}" ''
          set -euo pipefail
          ${pre}
          ${jq} -cn \
            --arg text "${text}" \
            --arg tooltip "${tooltip}" \
            --arg alt "${alt}" \
            --arg class "${class}" \
            --arg percentage "${percentage}" \
            '{text:$text,tooltip:$tooltip,alt:$alt,class:$class,percentage:$percentage}'
        ''}/bin/waybar-${name}";
    in
    {
      enable = true;

      package = pkgs.waybar.overrideAttrs (oa: {
        mesonFlags = (oa.mesonFlags or [ ]) ++ [ "-Dexperimental=true" ];
      });

      systemd.enable = true;

      settings = {

        primary = {
          # mode = "dock";
          layer = "top";
          height = 25;
          margin = "6";
          position = "top";
          modules-left = [
            "sway/workspaces"
            "sway/mode"
            "custom/separator"
            "custom/currentplayer"
            "custom/player"
          ];
          modules-center = [
            "clock"
          ];
          modules-right = [
            "cpu"
            "memory"
            "custom/menu"
            "backlight"
            "network"
            "pulseaudio"
            "battery"
            "tray"
            "custom/hostname"
          ];

          "custom/separator" = {
            return-type = "text";
            interval = "once";
            format = "|";
            tooltip = false;
          };

          "wlr/workspaces" = {
            on-click = "activate";
          };

          "sway/workspaces" = {
            format = "{icon}";
            all-outputs = false;
            disable-scroll = false;
            persistent-workspaces = { };
            on-click = "focus";
            on-scroll-up = "swaymsg workspace next";
            on-scroll-down = "swaymsg workspace prev";
            format-icons = {
              "1" = " ";
              "2" = "";
              "3" = " ";
              "4" = " ";
              "5" = " ";
              urgent = "";
              # focused = "";
              # default = "";
            };
          };

          "sway/mode" = {
            format = "<span style=\"italic\">{}</span>";
          };

          "backlight" = {
            device = "{icon} {percent: >3}%";
            format = "{percent}% {icon}";
            format-icons = [
              "󰃞 "
              "󰃟 "
              "󰃠 "
            ];
          };

          clock = {
            format = "{:%d/%m %H:%M}";
            tooltip-format = ''
              <big>{:%Y %B}</big>
              <tt><small>{calendar}</small></tt>'';
          };
          cpu = {
            format = "   {usage}%";
            #on-click = systemMonitor;
          };
          memory = {
            format = "󰍛  {}%";
            interval = 5;
            enable = true;
            #on-click = systemMonitor;
          };
          pulseaudio = {
            format = "{icon}  {volume}%";
            format-muted = "   0%";
            format-icons = {
              headphone = "󰋋";
              headset = "󰋎";
              portable = "";
              default = [
                ""
                ""
                " "
              ];
            };
            on-click = "${pavucontrol}";
          };
          battery = {
            bat = "BAT0";
            interval = 10;
            format-icons = [
              "󰁺"
              "󰁻"
              "󰁼"
              "󰁽"
              "󰁾"
              "󰁿"
              "󰂀"
              "󰂁"
              "󰂂"
              "󰁹"
            ];
            format = "{icon} {capacity}%";
            format-charging = "󰂄 {capacity}%";
            onclick = "";
          };
          "sway/window" = {
            max-length = 20;
          };
          network = {
            interval = 3;
            format-wifi = "   {essid}";
            format-ethernet = "󰈁 Connected";
            format-disconnected = "";
            tooltip-format = ''
              {ifname}
              {ipaddr}/{cidr}
              Up: {bandwidthUpBits}
              Down: {bandwidthDownBits}'';
            on-click = "nm-connection-editor";
          };
          "custom/menu" = {
            return-type = "json";
            exec = jsonOutput "menu" {
              text = "";
              tooltip = ''$(cat /etc/os-release | grep PRETTY_NAME | cut -d '"' -f2)'';
            };
            on-click = "${rofi} -show drun";
          };
          "custom/hostname" = {
            exec = "echo $USER@$(hostname)";
            on-click = "${terminal}";
          };
          "custom/currentplayer" = {
            interval = 2;
            return-type = "json";
            exec = jsonOutput "currentplayer" {
              pre = ''
                player="$(${playerctl} status -f "{{playerName}}" 2>/dev/null || echo "No player active" | cut -d '.' -f1)"
                count="$(${playerctl} -l | wc -l)"
                if ((count > 1)); then
                more=" +$((count - 1))"
                else
                more=""
                fi
              '';
              alt = "$player";
              tooltip = "$player ($count available)";
              text = "$more";
            };
            format = "{icon}{text}";
            format-icons = {
              "No player active" = " ";
              "Celluloid" = "󰎁 ";
              "spotify" = " 󰓇";
              "ncspot" = " 󰓇";
              "qutebrowser" = "󰖟";
              "firefox" = " ";
              "discord" = " 󰙯 ";
              "sublimemusic" = " ";
              "kdeconnect" = "󰄡 ";
            };
            on-click = "${playerctld} shift";
            on-click-right = "${playerctld} unshift";
          };
          "custom/player" = {
            exec-if = "${playerctl} status";
            exec = ''${playerctl} metadata --format '{"text": "{{artist}} - {{title}}", "alt": "{{status}}", "tooltip": "{{title}} ({{artist}} - {{album}})"}' '';
            return-type = "json";
            interval = 2;
            max-length = 30;
            format = "{icon} {text}";
            format-icons = {
              "Playing" = "󰏤";
              "Paused" = "󰐊";
              "Stopped" = "󰓛";
            };
            on-click = "${playerctl} play-pause";
          };
        };

      };
      # Cheatsheet:
      # x -> all sides
      # x y -> vertical, horizontal
      # x y z -> top, horizontal, bottom
      # w x y z -> top, right, bottom, left
      style =
        let
          inherit (config.colorscheme) colors;
        in
        # css
        ''
          * {
            font-family: ${config.fontProfiles.regular.family}, ${config.fontProfiles.monospace.family};
            font-size: 12pt;
            padding: 0 8px;
          }

          .modules-right {
            margin-right: -15px;
          }

          .modules-left {
            margin-left: -15px;
          }

          window#waybar.top {
            opacity: 0.95;
            padding: 0;
            background-color: #${colors.base00};
            border: 1px solid #${colors.base0C};
            border-radius: 10px;
          }
          window#waybar.bottom {
            opacity: 0.90;
            background-color: #${colors.base00};
            border: 1px solid #${colors.base0C};
            border-radius: 10px;
          }

          window#waybar {
            color: #${colors.base05};
          }

          #workspaces button {
            background-color: #${colors.base01};
            color: #${colors.base05};
            margin: 4px;
          }
          #workspaces button.hidden {
            background-color: #${colors.base00};
            color: #${colors.base04};
          }
          #workspaces button.focused,
          #workspaces button.active {
            background-color: #${colors.base0A};
            color: #${colors.base00};
          }

          #clock {
            background-color: #${colors.base0C};
            color: #${colors.base00};
            padding-left: 15px;
            padding-right: 15px;
            margin-top: 0;
            margin-bottom: 0;
            border-radius: 10px;
          }

          #custom-menu {
            background-color: #${colors.base0C};
            color: #${colors.base00};
            padding-left: 15px;
            padding-right: 22px;
            margin-left: 10px;
            margin-right: 10px;
            margin-top: 0;
            margin-bottom: 0;
            border-radius: 10px;
          }
          #custom-hostname {
            background-color: #${colors.base0C};
            color: #${colors.base00};
            padding-left: 15px;
            padding-right: 18px;
            margin-right: 0;
            margin-top: 0;
            margin-bottom: 0;
            border-radius: 10px;
          }
          #custom-currentplayer {
            margin-left: 0;
            padding-right: 5px;
          }

          #custom-player {
            margin-left: 0;
            padding-left: 5px;
          }

          #custom-separator {
            color: #${colors.base03};
            padding: 0 6px;
            font-weight: bold;
          }

          #tray {
            color: #${colors.base05};
          }
        '';
    };
}
