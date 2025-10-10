{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (config.colorscheme) colors;
in
{
  programs.kitty = {
    enable = true;
    shellIntegration.enableBashIntegration = true;
    shellIntegration.enableFishIntegration = true;
    settings = {

      shell = "${lib.getExe pkgs.fish}";

      confirm_os_window_close = 0;

      scrollback_lines = -1;

      background = "#${colors.base00}";
      foreground = "#${colors.base05}";

      # Black
      color0 = "#${colors.base00}";
      color8 = "#${colors.base03}";
      # Red
      color1 = "#${colors.base08}";
      color9 = "#${colors.base08}";
      # Green
      color2 = "#${colors.base0B}";
      color10 = "#${colors.base0B}";

      # Yellow
      color3 = "#${colors.base0A}";
      color11 = "#${colors.base0A}";

      # Blue
      color4 = "#${colors.base0D}";
      color12 = "#${colors.base0D}";

      # Magenta
      color5 = "#${colors.base0E}";
      color13 = "#${colors.base0E}";

      # Cyan
      color6 = "#${colors.base0C}";
      color14 = "#${colors.base0C}";

      # White
      color7 = "#${colors.base05}";
      color15 = "#${colors.base07}";

      # Tab colors
      active_tab_background = "#${colors.base02}";
      active_tab_foreground = "#${colors.base05}";
      inactive_tab_background = "#${colors.base00}";
      inactive_tab_foreground = "#${colors.base03}";

      notify_on_cmd_finish = "invisible 20";

    };

    extraConfig = ''
      font_family FiraCode Nerd Font
      # copy_on_select yes

      # Tab management using keyboard shortcuts
      # Open a new tab
      map ctrl+shift+t new_tab

      # Navigate to the next tab
      map ctrl+shift+right next_tab

      # Navigate to the previous tab
      map ctrl+shift+left previous_tab

      # Close the current tab
      map ctrl+shift+q close_tab

      # Copy paste
      map ctrl+shift+c copy_to_clipboard

      # Bonus: Jump to a specific tab by its number
      map alt+1 goto_tab 1
      map alt+2 goto_tab 2
      map alt+3 goto_tab 3
      map alt+4 goto_tab 4
      map alt+5 goto_tab 5
      map alt+6 goto_tab 6
      map alt+7 goto_tab 7
      map alt+8 goto_tab 8
      map alt+9 goto_tab 9
    '';
  };
}
