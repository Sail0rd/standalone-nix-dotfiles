{
  pkgs,
  lib,
  self,
  config,
  ...
}:

let

  wallpaper = builtins.fetchurl {
    url = "https://i.redd.it/7lnsnj1104391.jpg";
    sha256 = "3a874c85c362bf50c3adfa80361bc10b3b3da9849533a503f7d0bc364eb45aab";
  };

  # Packages
  grimCmd = "${lib.getExe pkgs.grim}";
  flameshotCmd = "QT_QPA_PLATFORM=xcb ${lib.getExe pkgs.flameshot}"; # workaround found in https://github.com/flameshot-org/flameshot/issues/2364
  kittyCmd = "${lib.getExe pkgs.kitty}";
  rofiCmd = "${lib.getExe pkgs.rofi}";
  slurpCmd = "${lib.getExe pkgs.slurp}";
  brightnessctlCmd = "${lib.getExe pkgs.brightnessctl}";
  playerctlCmd = "${lib.getExe pkgs.playerctl}";
  wl-copyCmd = "${pkgs.wl-clipboard}/bin/wl-copy";
  wl-pasteCmd = "${pkgs.wl-clipboard}/bin/wl-paste";

  # Screenshot command for Sway
  screenshot = "${grimCmd} -g \"$(${slurpCmd})\" - | ${wl-copyCmd}";

  dmenu = "${rofiCmd} -modi drun -show drun -show-icons";
in
{
  home.packages = with pkgs; [
    swaybg # background image
    grim # Screenshot utility
    slurp # Screenshot selector
    wlr-randr # Monitor configuration
    wl-clipboard # Clipboard utilities
    wdisplays # GUI for wlr-randr
    playerctl # Media control
    brightnessctl # Screen brightness
  ];

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
    size = 24;
  };

  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.sway;
    checkConfig = true;
    systemd.enable = true;

    config = {
      modifier = "Mod4"; # $mod -> SUPER
      terminal = "${kittyCmd}";
      menu = dmenu;

      startup = [
        { command = "${lib.getExe pkgs.swaybg} -i ${wallpaper}"; }
        { command = "${lib.getExe pkgs.kanshi}"; }
        # { command = "${lib.getExe pkgs.waybar}"; } # Uncomment if using Waybar
      ];

      window = {
        # hideEdgeBorders = "smart";
        titlebar = false;
      };

      workspaceOutputAssign = lib.map (monitor: {
        output = monitor.name;
        workspace = monitor.workspace;
      }) config.monitors;

      output = {
        "*" = {
          scale = "1";
        };
      };

      input = {
        "*" = {
          xkb_layout = "us";
          xkb_variant = "colemak";
        };
      };

      focus.followMouse = "yes";

      defaultWorkspace = "workspace number 1";
      keybindings =
        let
          mod = "Mod4";
        in
        lib.mkOptionDefault {
          # Applications
          "${mod}+Return" = "exec ${kittyCmd}";
          "${mod}+d" = "exec ${dmenu}";
          "Print" = "exec ${screenshot}";
          # "${mod}+Shift+s" = "exec ${screenshot}";
          "${mod}+Shift+s" = "exec ${flameshotCmd} gui";
          "${mod}+x" = "exec swaylock --image ${self}/assets/cube.jpg";

          # Brightness
          "XF86MonBrightnessDown" = "exec ${brightnessctlCmd} set 5%-";
          "XF86MonBrightnessUp" = "exec ${brightnessctlCmd} set +5%";

          # Volume controls
          "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+";
          "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-";
          "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";

          # Media
          "XF86AudioPlay" = "exec ${playerctlCmd} play-pause";
          "XF86AudioPause" = "exec ${playerctlCmd} play-pause";
          "XF86AudioNext" = "exec ${playerctlCmd} next";
          "XF86AudioPrev" = "exec ${playerctlCmd} previous";

          # Window management
          "${mod}+q" = "kill";
          "${mod}+Shift+e" = "exec ${rofiCmd} -show drun";
          "${mod}+p" = "floating toggle";
          "${mod}+f" = "fullscreen toggle";
          "${mod}+t" = "layout toggle split stacking tabbed"; # toggle between layouts

          # Move focus
          "${mod}+h" = "focus left";
          "${mod}+j" = "focus down";
          "${mod}+k" = "focus up";
          "${mod}+l" = "focus right";

          # Move windows
          "${mod}+Shift+h" = "move left";
          "${mod}+Shift+j" = "move down";
          "${mod}+Shift+k" = "move up";
          "${mod}+Shift+l" = "move right";

          # Resize windows (Sway uses "mode" for resize)
          "${mod}+Ctrl+h" = "resize shrink width 10px";
          "${mod}+Ctrl+j" = "resize grow height 10px";
          "${mod}+Ctrl+k" = "resize shrink height 10px";
          "${mod}+Ctrl+l" = "resize grow width 10px";

          # Move workspace between monitors
          "${mod}+bracketleft" = "move workspace to output left";
          "${mod}+bracketright" = "move workspace to output right";
        };

      # Workspaces: mod+[1..10], mod+Shift+[1..10]
      keycodebindings =
        let
          mod = "Mod4";
        in
        builtins.listToAttrs (
          builtins.concatMap (
            x:
            let
              ws = toString (x + 1);
            in
            [
              {
                name = "${mod}+${ws}";
                value = "workspace number ${ws}";
              }
              {
                name = "${mod}+Shift+${ws}";
                value = "move container to workspace number ${ws}";
              }
            ]
          ) (lib.range 0 8)
        );

      bars = [
        # {
        #   command = "${pkgs.waybar}/bin/waybar";
        #   position = "top";
        #   workspaceButtons = true;
        #   workspaceNumbers = true;
        # }
      ];

      gaps = {
        inner = 10;
        outer = 3;
        # smartGaps = true;
      };
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
    config = {
      sway = {
        default = [
          "wlr"
          "gtk"
        ];
      };
    };
  };

  xdg.desktopEntries.sway = {
    name = "Sway";
    comment = "A tiling Wayland compositor compatible with i3 config";
    exec = "nixGL sway";
    type = "Application";
    terminal = false;
    categories = [
      "System"
      "X-Window Manager"
    ];
  };

}
