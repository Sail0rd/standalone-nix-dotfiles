{ config, ... }:
let
  inherit (config.colorscheme) colors;
in
{
  programs.zathura = {
    enable = true;
    options = {
      selection-clipboard = "clipboard";
      font = "${config.fontProfiles.regular.family} 12";
      recolor = true;
      default-bg = "#${colors.base00}";
      default-fg = "#${colors.base01}";
      statusbar-bg = "#${colors.base02}";
      statusbar-fg = "#${colors.base04}";
      inputbar-bg = "#${colors.base00}";
      inputbar-fg = "#${colors.base07}";
      notification-bg = "#${colors.base00}";
      notification-fg = "#${colors.base07}";
      notification-error-bg = "#${colors.base00}";
      notification-error-fg = "#${colors.base08}";
      notification-warning-bg = "#${colors.base00}";
      notification-warning-fg = "#${colors.base08}";
      highlight-color = "#${colors.base0A}";
      highlight-active-color = "#${colors.base0D}";
      completion-bg = "#${colors.base01}";
      completion-fg = "#${colors.base05}";
      completions-highlight-bg = "#${colors.base0D}";
      completions-highlight-fg = "#${colors.base07}";
      recolor-lightcolor = "#${colors.base00}";
      recolor-darkcolor = "#${colors.base06}";
    };

    extraConfig = ''
        map b adjust_window best-fit
        map w adjust_window width
        map r reload
        map p print
        map c recolor
        map J zoom out
        map K zoom in
        map j scroll down
        map k scroll up
        map g scroll full-up
        map G scroll full-down
        map ? search backward
        map R rotate
        map <Return> toggle_presentation
        map [presentation] <Return> toggle_presentation
        unmap f
        map f toggle_fullscreen
        map [fullscreen] f toggle_fullscreen

      # Index mode
        map [index] i toggle_index
        map [index] <Right> navigate_index up
        map [index] <Left> navigate_index down
        map [index] u navigate_index select
        map [index] + navigate_index expand
        map [index] - navigate_index collapse
        map [index] <Tab> navigate_index toggle

      # Unfortunately, there is no "toggle-all":
        map [index] <ShiftTab> navigate_index expand-all
        map [index] <A-ShiftTab> navigate_index collapse-all
    '';
  };
}
