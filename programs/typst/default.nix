{
  pkgs,
  lib,
  config,
  ...
}:

{
  home.packages = with pkgs; [
    typst
    typstfmt
    # typst-lsp
  ];

  programs.nixvim.plugins = {
    typst-vim = {
      enable = true;
      settings = {
        concealMath = true;
      } // lib.optionalAttrs config.programs.zathura.enable { pdfViewer = "zathura"; };
    };
    lsp.servers.typst-lsp = {
      enable = true;
    };
  };
}
