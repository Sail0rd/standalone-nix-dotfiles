{ pkgs, ... }:
let
  custom-kubernetes-helm =
    with pkgs;
    wrapHelm kubernetes-helm {
      plugins = with pkgs.kubernetes-helmPlugins; [
        helm-secrets
        helm-diff
        helm-s3
        helm-git
      ];
    };

  custom-helmfile =
    with pkgs;
    helmfile-wrapped.override { inherit (custom-kubernetes-helm.passthru) pluginsDir; };
in

{
  environment.systemPackages = with pkgs; [
    custom-kubernetes-helm
    custom-helmfile
  ];
}
