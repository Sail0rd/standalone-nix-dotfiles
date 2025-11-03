{ pkgs, ... }:
with pkgs;
[
  (jeezyvim.extend {
    # clipboard.providers.xclip.enable = true;
    clipboard.providers.wl-copy.enable = true;
    plugins = {
      # vimtex = {
      #   enable = true;
      #   texlivePackage = pkgs.texliveFull;
      #   settings = {
      #     view_method = "zathura";
      #     compiler_latexmk_engines = {
      #       "_" = "-xelatex";
      #     };
      #   };
      # };
      none-ls = {
        sources = {
          diagnostics.sqruff = {
            enable = true;
            settings = {
              extra_args = [
                "--dialect"
                "postgres"
              ];
            };
          };
          formatting = {
            shfmt.enable = false;
            terraform_fmt.enable = false;
          };
        };
      };
      # copilot-vim = {
      #   enable = true;
      #   settings.filetypes = {
      #     "*" = true;
      #   };
      # };
      windsurf-vim = {
        enable = true;
        settings.filetypes = {
          "*" = true;
        };
      };
    };
  })
]
