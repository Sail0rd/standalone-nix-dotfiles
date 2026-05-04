{ pkgs, ... }:
{
  home.packages = [
    (pkgs.slack.overrideAttrs (oldAttrs: {
      nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ pkgs.makeWrapper ];

      postInstall = (oldAttrs.postInstall or "") + ''
        wrapProgram $out/bin/slack \
          --append-flags "--no-sandbox"
      '';
    }))
  ];

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
}
