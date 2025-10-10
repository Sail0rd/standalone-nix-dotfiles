{
  pkgs,
  lib,
  self,
  ...
}:
let
  # Packages
  hyprshot = "${lib.getExe pkgs.hyprshot}";
  # hyprlock = "${lib.getExe pkgs.hyprlock}";
  grim = "${lib.getExe pkgs.grim}";
  kitty = "${lib.getExe pkgs.kitty}";
  rofi = "${lib.getExe pkgs.rofi}";
  slurp = "${lib.getExe pkgs.slurp}";
  brightnessctl = "${lib.getExe pkgs.brightnessctl}";
  playerctl = "${lib.getExe pkgs.playerctl}";
  wl-copy = "${pkgs.wl-clipboard}/bin/wl-copy"; # wl-clipboard expose multiple binaries
  wl-paste = "${pkgs.wl-clipboard}/bin/wl-paste";

  applicationsShortcut =
    let
      term = "${kitty}";
      dmenu = "${rofi} -modi drun -show drun -show-icons";
      screenshot = "${hyprshot} -m region --freeze --output-folder ~/Pictures/";
    in
    ''
      bind = $mod, Return, exec, ${term}
      bind = $mod, D, exec, ${dmenu}
      bind = , PRINT, exec, ${screenshot}
      bind = $mod SHIFT, S, exec, ${screenshot}
      bind = $mod, X, exec, swaylock --image ${self}/assets/cube.jpg

      binde = , XF86MonBrightnessDown, exec, ${brightnessctl} set 5%-
      binde = , XF86MonBrightnessUp, exec, ${brightnessctl} set 5%+

      binde = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+
      binde = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-
      bindl = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

      bindl = , XF86AudioPlay, exec, ${playerctl} play-pause
      bindl = , XF86AudioPause, exec, ${playerctl} play-pause
      bindl = , XF86AudioNext, exec, ${playerctl} next
      bindl = , XF86AudioPrev, exec, ${playerctl} previous
    '';

  compositorControl = ''
    bind = $mod, Q, killactive,
    bind = $mod SHIFT, E, exec, ${rofi} -show drun
    bind = $mod, P, togglefloating,
    bind = $mod, Enter, exec, ${kitty}
    # bind = $mod Shift, S, exec, ${grim} -g \"$(slurp)\"
    bind = $mod, F, fullscreen

    # Move focus
    bind = $mod, H, movefocus, l
    bind = $mod, J, movefocus, d
    bind = $mod, K, movefocus, u
    bind = $mod, L, movefocus, r

    # Move windows
    bind = $mod SHIFT, H, movewindow, l
    bind = $mod SHIFT, J, movewindow, d
    bind = $mod SHIFT, K, movewindow, u
    bind = $mod SHIFT, L, movewindow, r

    # Resize windows
    bind = $mod CTRL, H, resizeactive, -10 0
    bind = $mod CTRL, J, resizeactive, 0 10
    bind = $mod CTRL, K, resizeactive, 0 -10
    bind = $mod CTRL, L, resizeactive, 10 0


    # Move the current workspace to the next monitor
    bind = $mod, bracketleft, movecurrentworkspacetomonitor, +1

    # Move the current workspace to the previous monitor
    bind = $mod, bracketright, movecurrentworkspacetomonitor, -1
  '';

  workspaceControl = ''
    # workspaces
    # binds mod + [shift +] {1..10} to [move to] ws {1..10}
    ${builtins.concatStringsSep "\n" (
      builtins.genList (
        x:
        let
          ws =
            let
              c = (x + 1) / 10;
            in
            builtins.toString (x + 1 - (c * 10));
        in
        ''
          bind = $mod, ${ws}, workspace, ${toString (x + 1)}
          bind = $mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}
        ''
      ) 10
    )}

    bind = $mod, u, togglespecialworkspace
    bind = $mod SHIFT, u, movetoworkspace, special
    bind = $mod, mouse_down, workspace, e+1
    bind = $mod, mouse_up, workspace, e-1
  '';

  general = ''
    monitor=eDP-1, preferred, auto, 1
    monitor=, preferred, auto, 1

    input {
      kb_layout = us
      kb_variant = colemak
      follow_mouse = 1 # Cursor movement will always change focus to the window under the cursor.
      numlock_by_default = true
    }
  '';
in
{
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
    size = 24;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    settings = {
      "$mod" = "SUPER";
      exec-once = [
        "${lib.getExe pkgs.hyprpaper}"
        "${lib.getExe pkgs.kanshi}"
        # "${lib.getExe pkgs.waybar}"
      ];
    };

    extraConfig = ''
      ${workspaceControl}
      ${compositorControl}
      ${applicationsShortcut}
      ${general}
    '';
  };

  xdg.portal = {
    enable = true;
    # extraPortals = [
    #   # pkgs.xdg-desktop-portal-gnome
    #   pkgs.xdg-desktop-portal-gtk
    # ];
    config = {
      hyprland = {
        default = [
          "hyprland"
          # "gtk"
        ];
        "org.freedesktop.impl.portal.ScreenCast" = [
          "hyprland"
        ];
      };
    };
  };
  xdg.desktopEntries.hyprland = {
    name = "Hyprland";
    comment = "A dynamic tiling Wayland compositor";
    exec = "nixGL Hyprland";
    type = "Application";
    terminal = false;
    categories = [
      "System"
      "X-Window Manager"
    ];
  };

  systemd.user.services."xdg-desktop-portal-hyprland" = {
    Unit = {
      Description = "xdg-desktop-portal backend for Hyprland (nixGL wrapped)";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.nixgl.nixGLMesa}/bin/nixGLMesa ${pkgs.xdg-desktop-portal-hyprland}/libexec/xdg-desktop-portal-hyprland";
      Restart = "on-failure";
      Slice = "session.slice";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  systemd.user.services."xdg-desktop-portal" = {
    Unit = {
      Description = "XDG Desktop Portal (Nix version)";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.xdg-desktop-portal}/libexec/xdg-desktop-portal";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

}
