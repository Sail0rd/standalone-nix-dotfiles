{ config, ... }:
let
  inherit (config.colorScheme) colors kind;
in
{
  services.mako = {
    enable = true;
    settings = {
      font = "${config.fontProfiles.regular.family} 12";
      padding = "10,20";
      anchor = "top-right";
      width = 400;
      icons = 1;
      height = 150;
      border-size = 2;
      default-timeout = 15 * 1000; # 15s
      background-color = "#${colors.base00}dd";
      border-color = "#${colors.base03}dd";
      text-color = "#${colors.base07}";
    };
  };
}
