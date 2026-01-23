{ inputs, pkgs, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;

  zen = inputs.zen-browser.packages.${system}.default;

  zen-nixgl = pkgs.writeShellScriptBin "zen-browser" ''
    exec ${pkgs.nixgl.nixGLMesa}/bin/nixGLMesa \
      ${zen}/bin/zen "$@"
  '';
in
{
  home.packages = [
    zen-nixgl
  ];

  xdg.desktopEntries."zen-browser" = {
    name = "Zen Browser";
    comment = "NixGL wrapped Zen web browser";
    exec = "zen-browser %U";
    icon = "zen-browser";
    terminal = false;
    categories = [
      "Network"
      "WebBrowser"
    ];
    mimeType = [
      "text/html"
      "text/xml"
      "application/xhtml+xml"
      "application/xml"
      "application/rss+xml"
      "application/rdf+xml"
      "image/gif"
      "image/jpeg"
      "image/png"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/ftp"
      "x-scheme-handler/chrome"
      "video/webm"
      "application/x-xpinstall"
    ];
  };
}
