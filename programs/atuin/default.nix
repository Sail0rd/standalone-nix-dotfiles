{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs.atuin = {
    enable = true;
    settings = {
      enter_accept = false;
    };
  }
  // lib.attrsets.optionalAttrs config.programs.fish.enable { enableFishIntegration = true; };
}
