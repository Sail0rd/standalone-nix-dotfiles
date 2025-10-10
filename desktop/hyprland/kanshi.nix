{ ... }:
{
  services.kanshi = {
    enable = true;
    systemdTarget = "hyprland-session.target";
    profiles = {
      docked = {
        outputs = [
          {
            criteria = "ASUSTek COMPUTER INC VG27AQ1A R4LMQS185790";
            mode = "2560x1440@60Hz";
            position = "0,0";
          }
          {
            criteria = "eDP-1";
            mode = "2560x1440@165Hz";
            position = "2560,0";
          }
          {
            criteria = "Microstep MSI G24C4 0x000001F8";
            mode = "1920x10800@144Hz";
            position = "5120,0";
          }
        ];
      };
      undocked = {
        outputs = [
          {
            criteria = "eDP-1";
            mode = "2560x1440@165Hz";
            position = "0,0";
          }
        ];
      };
    };
  };

}
