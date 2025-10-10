{
  config,
  lib,
  pkgs,
  ...
}:
let
  # Define the path to Trackwarrior repository or files
  trackwarriorRepo = pkgs.fetchFromGitHub {
    owner = "Sail0rd";
    repo = "trackwarrior";
    rev = "7d6178e9215a27dc6e016cb177202d0e28d65ce1";
    hash = "sha256-JUMHD3aleb3tnmh4e5SZU+s3vQeUn9FVk03jAb1DWCQ=";
  };
  cfg = config.services.trackwarrior;
  homeConf = "${config.xdg.configHome}";
in
{
  options = {
    services.trackwarrior = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Trackwarrior (extension for Taskwarrior and Timewarrior)";
      };

      taskwarriorPackage = lib.mkPackageOption pkgs "taskwarrior3" { example = "pkgs.taskwarrior3"; };

      timewarriorPackage = lib.mkPackageOption pkgs "timewarrior" { example = "pkgs.taskwarrior3"; };

      colorTheme = lib.mkOption {
        type = lib.types.str;
        default = "dark-blue-256";
        description = "Color theme for Taskwarrior";
      };

      config = lib.mkOption {
        type = lib.types.attrsOf lib.types.anything;
        default = {
          uda = {
            trackwarrior = {
              type = "string";
              label = "Elapsed Time";
              values = "";
            };
            trackwarrior_rate = {
              type = "string";
              label = "Rate";
              values = "";
            };
            trackwarrior_total_amount = {
              type = "string";
              label = "Total Amount";
              values = "";
            };
          };
          report.list.columns = [
            "id"
            "trackwarrior"
            "priority"
            "project"
            "due"
            "description"
            "urgency"
            "tags"
          ];
          report.list.labels = [
            "ID"
            "Time"
            "Priority"
            "Project"
            "Due"
            "Description"
            "Urgency"
            "Tags"
          ];
        };

        description = ''
          Key-value configuration written to
          {file}`$XDG_CONFIG_HOME/task/taskrc`.
        '';
      };

      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = ''
          max_active_tasks=1
          erase_time_on_delete=false
          clear_time_tags=cleartime,ctime,deletetime,dtime
          update_time_tags=update,updatetime,utime,recalc
          create_time_when_add_task=false
          rate_per_hour=10
          rate_per_hour_decimals=2
          rate_per_hour_project=Inbox:0,Other:10
          rate_format_with_spaces=10
          currency_format=de-DE,EUR
        '';
        description = ''
          Additional content written at the end of
          {file}`$XDG_CONFIG_HOME/task/taskrc`.
        '';
      };
    };
  };

  # Set the configuration
  config = lib.mkIf cfg.enable {
    # Ensure Taskwarrior and Timewarrior are enabled
    programs.taskwarrior = {
      enable = lib.mkDefault true;
      package = lib.mkDefault cfg.taskwarriorPackage;
      colorTheme = lib.mkDefault cfg.colorTheme;
      dataLocation = lib.mkDefault "$HOME/.config/task";
      config = lib.mkDefault cfg.config;
      extraConfig = lib.mkDefault cfg.extraConfig;
    };

    home = {
      packages = [ cfg.timewarriorPackage ];

      file."${homeConf}/task/hooks/" = {
        source = "${trackwarriorRepo}/taskwarrior/hooks";
        recursive = true;
      };

      file."${homeConf}/timewarrior/extensions/" = {
        source = "${trackwarriorRepo}/timewarrior/extensions";
        recursive = true;
      };
    };
  };
}
