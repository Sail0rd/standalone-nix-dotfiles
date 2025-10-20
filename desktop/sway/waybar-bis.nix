{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  commonDeps = with pkgs; [
    coreutils
    gnugrep
    systemd
  ];
  # Function to simplify making waybar outputs
  mkScript =
    {
      name ? "script",
      deps ? [ ],
      script ? "",
    }:
    lib.getExe (
      pkgs.writeShellApplication {
        inherit name;
        text = script;
        runtimeInputs = commonDeps ++ deps;
      }
    );
  # Specialized for JSON outputs
  mkScriptJson =
    {
      name ? "script",
      deps ? [ ],
      script ? "",
      text ? "",
      tooltip ? "",
      alt ? "",
      class ? "",
      percentage ? "",
    }:
    mkScript {
      inherit name;
      deps = [ pkgs.jq ] ++ deps;
      script = ''
        ${script}
        jq -cn \
          --arg text "${text}" \
          --arg tooltip "${tooltip}" \
          --arg alt "${alt}" \
          --arg class "${class}" \
          --arg percentage "${percentage}" \
          '{text:$text,tooltip:$tooltip,alt:$alt,class:$class,percentage:$percentage}'
      '';
    };

  swayCfg = config.wayland.windowManager.sway;
  hyprlandCfg = config.wayland.windowManager.hyprland;
in
{
  systemd.user.services.waybar = {
    Unit = {
      # Let it try to start a few more times
      StartLimitBurst = 30;
      # Reload instead of restarting
      X-Restart-Triggers = lib.mkForce [ ];
      X-SwitchMethod = "reload";
    };
  };
  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oa: {
      mesonFlags = (oa.mesonFlags or [ ]) ++ [ "-Dexperimental=true" ];
    });
    systemd.enable = true;
    settings = {
      primary = {
        exclusive = false;
        passthrough = false;
        layer = "top";
        height = 40;
        margin = "6";
        position = "top";
        modules-left = [
          "custom/menu"
        ]
        ++ (lib.optionals swayCfg.enable [
          "sway/workspaces"
          "sway/mode"
        ])
        ++ (lib.optionals hyprlandCfg.enable [
          "hyprland/workspaces"
          "hyprland/submap"
        ])
        ++ [
          "custom/currentplayer"
          "custom/player"
        ];

        modules-right = [
          "tray"
          "network"
          "custom/rfkill"
          "battery"
          "pulseaudio"
          "clock"
        ];

        clock = {
          format = "{:%H:%M %d/%m}";
          on-click-left = "mode";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
        };

        cpu = {
          interval = 5;
          format = "  {usage}%";
        };
        "custom/gpu" = {
          interval = 5;
          exec = mkScript { script = "cat /sys/class/drm/card*/device/gpu_busy_percent | head -1"; };
          format = "󰒋  {}%";
        };
        memory = {
          format = "  {}%";
          interval = 5;
        };

        "pulseaudio" = {
          format = "{icon}{format_source}";
          format-bluetooth = "{icon} 󰂯{format_source}";
          format-source = "";
          format-source-muted = " 󰍭";
          format-icons = {
            default-muted = "󰸈";
            default = [
              "󰕿"
              "󰖀"
              "󰖀"
              "󰕾"
            ];
            headphone-muted = "󰟎";
            headphone = "󰋋";
            headset-muted = "󰋐";
            headset = "󰋎";
          };
          on-click = lib.getExe pkgs.pavucontrol;
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "󰒳";
            deactivated = "󰒲";
          };
        };
        battery = {
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
          format = "{icon}";
          format-charging = "󰂄";
          tooltip-format = "{capacity}% ({time})";
          onclick = "";
        };
        "sway/window" = {
          max-length = 20;
        };
        network = {
          interval = 3;
          format-wifi = "󰖩";
          format-ethernet = "󰈀";
          format-disconnected = "";
          tooltip-format = ''
            {essid}
            {ifname}
            {ipaddr}/{cidr}
            Up: {bandwidthUpBits}
            Down: {bandwidthDownBits}'';
        };
        "custom/menu" = {
          return-type = "json";
          exec = mkScriptJson {
            tooltip = "$USER@$HOSTNAME";
            alt = "$(grep LOGO /etc/os-release | cut -d = -f2 | cut -d '\"' -f2)";
          };
          format = "{icon}";
          format-icons = {
            "nix-snowflake" = "";
            "ubuntu-logo" = "󰕈";
          };
        };
        "custom/currentplayer" = {
          interval = 2;
          return-type = "json";
          exec = mkScriptJson {
            deps = [ pkgs.playerctl ];
            script = ''
              all_players=$(playerctl -l 2>/dev/null)
              selected_player="$(playerctl status -f "{{playerName}}" 2>/dev/null || true)"
              clean_player="$(echo "$selected_player" | cut -d '.' -f1)"
            '';
            alt = "$clean_player";
            tooltip = "$all_players";
          };
          format = "{icon}{text}";
          format-icons = {
            "" = " ";
            "Celluloid" = "󰎁 ";
            "spotify" = "󰓇 ";
            "ncspot" = "󰓇 ";
            "qutebrowser" = "󰖟 ";
            "firefox" = " ";
            "discord" = " 󰙯 ";
            "sublimemusic" = " ";
            "kdeconnect" = "󰄡 ";
            "chromium" = " ";
          };
        };
        "custom/player" = {
          exec-if = mkScript {
            deps = [ pkgs.playerctl ];
            script = ''
              selected_player="$(playerctl status -f "{{playerName}}" 2>/dev/null || true)"
              playerctl status -p "$selected_player" 2>/dev/null
            '';
          };
          exec = mkScript {
            deps = [ pkgs.playerctl ];
            script = ''
              selected_player="$(playerctl status -f "{{playerName}}" 2>/dev/null || true)"
              playerctl metadata -p "$selected_player" \
                --format '{"text": "{{artist}} - {{title}}", "alt": "{{status}}", "tooltip": "{{artist}} - {{title}} ({{album}})"}' 2>/dev/null
            '';
          };
          return-type = "json";
          interval = 2;
          max-length = 30;
          format = "{icon} {text}";
          format-icons = {
            "Playing" = "󰐊";
            "Paused" = "󰏤 ";
            "Stopped" = "󰓛";
          };
          on-click = mkScript {
            deps = [ pkgs.playerctl ];
            script = "playerctl play-pause";
          };
        };
        "custom/minicava" = {
          exec = mkScript { script = lib.getExe (pkgs.minicava { }); };
          "restart-interval" = 5;
        };
        "custom/rfkill" = {
          interval = 3;
          exec-if = mkScript {
            deps = [ pkgs.util-linux ];
            script = "rfkill list wifi | grep yes -q";
          };
          exec = "echo 󰀝";
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
        inherit (inputs.nix-colors.lib.conversions) hexToRGBString;
        inherit (config.colorscheme) colors;
        toRGBA = color: opacity: "rgba(${hexToRGBString "," (lib.removePrefix "#" color)},${opacity})";
      in
      # css
      ''
        * {
          font-family: ${config.fontProfiles.regular.family}, ${config.fontProfiles.monospace.family};
          font-size: 12pt;
          padding: 0;
          margin: 0 0.4em;
        }

        window#waybar {
          padding: 0;
          background-color: transparent;
          color: #${colors.base05};
        }
        .modules-left {
          background-color: ${toRGBA colors.base00 "0.8"};
          margin-left: 0;
          border-radius: 0.5em;
          border-right: solid 0.4em #${colors.base00};
        }
        .modules-right {
          background-color: ${toRGBA colors.base00 "0.8"};
          margin-right: 0;
          border-radius: 0.5em;
          border-left: solid 0.4em #${colors.base00};
        }

        #workspaces button {
          color: #${colors.base05};
          padding-left: 0.2em;
          padding-right: 0.2em;
          margin-top: 0.15em;
          margin-bottom: 0.15em;
          margin-left: 0.1em;
          margin-right: 0.1em;
        }
        #workspaces button.hidden {
          background-color: #${colors.base00};
          color: #${colors.base01};
        }
        #workspaces button.focused,
        #workspaces button.active {
          background-color: #${colors.base0D};
          color: #${colors.base06};
        }

        #custom-menu {
          background-color: #${colors.base02};
          color: #${colors.base0D};
          padding-right: 1.5em;
          padding-left: 1em;
          margin-left: 0;
          border-radius: 0.5em;
        }
        #clock {
          background-color: #${colors.base02};
          color: #${colors.base0D};
          padding-right: 0.8em;
          padding-left: 0.7em;
          margin-right: 0;
          border-radius: 0.5em;
        }

        #custom-player {
          padding-left: 0;
          margin-left: 0;
          margin-right: 1em;
        }
        #custom-currentplayer {
          padding-right: 0;
          margin-left: 1em;
        }
        #tray {
          color: #${colors.base05};
        }
      '';
  };
}
