{ config, lib, ... }:
let
  primaryMonitor = lib.head (lib.filter (m: m.primary) config.monitors); # get only the monitor that is primary
in
{
  services.kanshi = {
    enable = true;
    settings = [
      {
        profile = {
          name = "laptop";
          outputs = [
            {
              criteria = primaryMonitor.name;
              mode = "${toString primaryMonitor.width}x${toString primaryMonitor.height}@${toString primaryMonitor.refreshRate}Hz";
              position = "${toString primaryMonitor.x},${toString primaryMonitor.y}";
              scale = primaryMonitor.scale;
            }
          ];
        };
      }
      {
        profile = {
          name = "docked";
          outputs = lib.map (monitor: {
            criteria = monitor.name;
            mode = "${toString monitor.width}x${toString monitor.height}@${toString monitor.refreshRate}Hz";
            position = "${toString monitor.x},${toString monitor.y}";
            scale = monitor.scale;
          }) config.monitors;
        };
      }
    ];
  };
}
