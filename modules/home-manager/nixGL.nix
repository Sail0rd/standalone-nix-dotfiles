{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.nixGLWrap;

  wrap =
    pkg:
    if cfg.prefix == "" then
      pkg
    else
      pkg.overrideAttrs (old: {
        name = "nixGL-${pkg.name}";

        buildCommand = ''
                      set -eo pipefail

                      ${lib.concatStringsSep "\n" (
                        map (outputName: ''
                          echo "Copying output ${outputName}"
                          cp -rs --no-preserve=mode "${pkg.${outputName}}" "''$${outputName}"
                        '') (old.outputs or [ "out" ])
                      )}

                      rm -rf $out/bin/*
                      shopt -s nullglob
                      for file in ${pkg.out}/bin/*; do
                        cat > "$out/bin/$(basename "$file")" <<EOF
          #!${pkgs.bash}/bin/bash
          exec -a "\$0" ${cfg.prefix} "$file" "\$@"
          EOF
                        chmod +x "$out/bin/$(basename "$file")"
                      done
                      shopt -u nullglob
        '';
      });
in
{
  ###### options ######

  options.nixGLWrap = {
    enable = lib.mkEnableOption "nixGL wrapping support";

    prefix = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "${pkgs.nixgl.nixGLMesa}/bin/nixGLMesa";
      description = ''
        Command prefix used to wrap binaries with nixGL.
        Leave empty to disable wrapping.
      '';
    };
  };

  ###### config ######

  config = lib.mkIf cfg.enable {
    lib.nixGLWrap.wrap = wrap;
  };
}
