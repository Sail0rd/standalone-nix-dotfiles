{ pkgs, config, ... }:
{
  programs.dank-material-shell = {
    enable = true;

    # quickshell.package = pkgs.quickshell;

    # systemd = {
    #   enable = true; # Systemd service for auto-start
    #   restartIfChanged = true; # Auto-restart dms.service when dankMaterialShell changes
    # };

    # Core features
    enableSystemMonitoring = true; # System monitoring widgets (dgop)
    # enableColorPicker = true; # Color picker widget
    enableVPN = true; # VPN management widget
    enableDynamicTheming = true; # Wallpaper-based theming (matugen)
    enableAudioWavelength = true; # Audio visualizer (cava)
    enableClipboardPaste = true; # Manage clipboard history
  };
}
