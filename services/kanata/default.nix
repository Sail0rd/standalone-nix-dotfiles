{
  pkgs,
  self,
  ...
}:
let
  kanata = self.packages.kanata;
  kanataConfig = "${self}/services/kanata/arsenik/kanata.kbd";
in
{
  home.packages = [ kanata ];

  systemd.user.services.kanata = {
    Unit = {
      Description = "Kanata keyboard remapper";
      Documentation = "https://github.com/jtroo/kanata";
      After = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${kanata}/bin/kanata --cfg ${kanataConfig}";
      Restart = "no";
      Environment = [
        "PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/bin"
        "DISPLAY=:0"
      ];
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
