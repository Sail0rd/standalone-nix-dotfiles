{ pkgs, self, ... }:
let
  wallpaper = builtins.fetchurl {
    url = "https://i.redd.it/7lnsnj1104391.jpg";
    sha256 = "3a874c85c362bf50c3adfa80361bc10b3b3da9849533a503f7d0bc364eb45aab";
  };

in
{
  home.packages = [ pkgs.hyprpaper ];
  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ${wallpaper}

    wallpaper = eDP-1,${wallpaper}
    wallpaper = DP-4,${wallpaper}
    wallpaper = DP-3,${wallpaper}
    wallpaper = DP-2,${wallpaper}
    wallpaper = DP-1,${wallpaper}
  '';
}
