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
      icon = 1;
      height = 150;
      borderSize = 2;
      defaultTimeout = 15 * 1000; # 15s
      backgroundColor = "#${colors.base00}dd";
      borderColor = "#${colors.base03}dd";
      textColor = "#${colors.base05}dd";
    };
  };
}
