{ lib, config, ... }:
{
  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };
}
