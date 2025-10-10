{ lib, config, ... }:
{
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
}
