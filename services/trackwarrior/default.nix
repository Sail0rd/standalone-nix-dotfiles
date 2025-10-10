{pkgs, ...}: {
  imports = [
    ../../../modules/home-manager/trackwarrior.nix
  ];
  services.trackwarrior = {
    enable = true;
  };
}
