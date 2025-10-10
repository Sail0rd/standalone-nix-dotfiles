{ config, pkgs, ... }:
let
  inherit (config.colorscheme) colors;
in
{

  # home.sessionVariables = {
  #   TERMINAL = "alacritty";
  # };

  programs.alacritty = {
    enable = true;

    settings = {
      live_config_reload = true;

      window = {
        title = "Terminal";
        opacity = 0.8;
      };

      # TODO: change this with a fontProfiles
      font = {
        normal.family = "Fira Code Nerd Font";
        normal.style = "Regular";
        size = 12.0;
      };

      cursor.style = "Underline";

      shell = {
        program = "${pkgs.fish}/bin/fish";
        # args = [ "--init-command" "echo; neofetch; echo" ];
      };

      colors = {
        primary = {
          background = "#${colors.base00}";
          foreground = "#${colors.base05}";
        };
        cursor = {
          text = "0xFF261E";
          cursor = "0xFF261E";
        };
        normal = {
          black = "#${colors.base00}";
          red = "#${colors.base08}";
          green = "#${colors.base0B}";
          yellow = "#${colors.base0A}";
          blue = "#${colors.base0D}";
          magenta = "#${colors.base0E}";
          cyan = "#${colors.base0C}";
          white = "#${colors.base05}";
        };
      };
    };
  };
}
