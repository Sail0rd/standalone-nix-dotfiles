{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.sshs;
  sshConf = "${config.home.homeDirectory}/.ssh";
in
{
  options = {

    services.sshs = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable sshs service";
      };

      sshKey = lib.mkOption {
        type = lib.types.path;
        default = "${sshConf}/id_rsa";
        description = ''
          Path to the SSH private key file to use for all connections
        '';
      };

      checkHostIP = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Check the IP address of the host before connecting
        '';
      };

      hostConfigs = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule {
            options = {
              hostName = lib.mkOption {
                type = lib.types.str;
                description = "The hostname or IP address of the server.";
              };

              user = lib.mkOption {
                type = lib.types.str;
                description = "The username for the SSH connection.";
              };

              port = lib.mkOption {
                type = lib.types.int;
                default = 22;
                description = "The port for the SSH connection.";
              };

              sshKey = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                description = "Optional private key to use for the connection.";
              };

              proxyCommand = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                description = "Optional proxy command for the connection.";
              };
            };
          }
        );
        default = { };
        description = ''
          Host-specific SSH configuration entries. Each entry should include
          hostName, user, port, and optionally proxyCommand.
          e.g.
          hostConfigs = {
            "My server" = {
              hostName = "server1.example.com";
              user = "root";
              port = 22;
              proxyCommand = null;
            };
          };
        '';
      };

      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Extra configuration to be added at the end of the ssh config file
        '';
      };
    };
  };

  # Set the configuration
  config = lib.mkIf cfg.enable {

    # install the sshs package
    home.packages = with pkgs; [ sshs ];

    home.file."${sshConf}/config" = {
      text =
        ''
          Host *
            AddKeysToAgent yes
            IdentityFile ${cfg.sshKey}
            CheckHostIP ${if cfg.checkHostIP then "yes" else "no"}

        ''
        + lib.concatStringsSep "\n" (
          map (hostName: ''
            Host ${hostName}
              HostName ${cfg.hostConfigs.${hostName}.hostName}
              User ${cfg.hostConfigs.${hostName}.user}
              Port ${toString cfg.hostConfigs.${hostName}.port}
              ${
                if cfg.hostConfigs.${hostName}.sshKey != null then
                  "IdentityFile ${cfg.hostConfigs.${hostName}.sshKey}"
                else
                  ""
              }
              ${
                if cfg.hostConfigs.${hostName}.proxyCommand != null then
                  "ProxyCommand ${cfg.hostConfigs.${hostName}.proxyCommand}"
                else
                  ""
              }
          '') (lib.attrNames cfg.hostConfigs)
        )
        + ''

          ${cfg.extraConfig}
        '';
    };
  };
}
