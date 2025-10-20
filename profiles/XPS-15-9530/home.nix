{
  config,
  pkgs,
  self,
  lib,
  inputs,
  user,
  hostname,
  email,
  ...
}:
let
  unstablePkgs =
    import ../../commonPackages/unstable.nix { inherit pkgs; }
    ++ (with pkgs; [
      # System
      spotify # Music Player
      discord # Chat

    ]);

  stablePkgs = import ../../commonPackages/stable.nix { inherit pkgs; };
  jeezyvim = import ../../programs/jeezyvim { inherit pkgs; };
in
{
  imports = [
    # ../../desktop/hyprland # Hyperland Desktop configuration
    ../../desktop/sway # sway desktop configuration

    ../../modules/home-manager/monitors.nix # Monitor configuration
    ../../modules/home-manager/fonts.nix # Font configuration

    # ../../programs/jeezyvim # Neovim portable configuration
    ../../programs/alacritty # Alacritty terminal configuration
    ../../programs/kitty # Kitty terminal configuration
    ../../programs/direnv # Direnv configuration
    ../../programs/flameshot # screenshot utility
    ../../programs/fish # Fish shell
    ../../programs/fzf # Fzf configuration
    ../../programs/git # Git user configuration
    ../../programs/lazygit # Lazygit configuration
    ../../programs/lsd # fancy ls
    ../../programs/nix-index # Nix index configuration
    ../../programs/rofi # Rofi app launcher
    ../../programs/starship # Starship prompt
    # ../../programs/swaylock # (fancy) Swaylock configuration WARN: Does not work
    # ../../programs/taskwarrior # Taskwarrior configuration
    # ../../programs/zathura # Zathura pdf viewer
    ../../programs/zoxide # Zoxide configuration

    ../../packages/helm.nix

    ../../services/podman # Podman configuration
  ];

  fontProfiles = {
    enable = true;
    monospace = {
      family = "FiraCode Nerd Font";
      package = pkgs.nerd-fonts.fira-code;
    };
    regular = {
      family = "Fira Sans";
      package = pkgs.fira;
    };
  };

  monitors = [
    {
      name = "eDP-1";
      refreshRate = 59.950;
      width = 1920;
      height = 1200;
      workspace = "1";
      primary = true;
      x = 1920;
      y = 1080;
    }
    {
      name = "DP-2";
      width = 1920;
      height = 1080;
      workspace = "2";
      primary = false;
      x = 1920;
      y = 0;
    }
    {
      name = "DP-3";
      width = 1920;
      height = 1080;
      workspace = "3";
      primary = false;
      x = 0;
      y = 520;
    }
  ];

  # Git config specific to this profile (signing, etc)
  programs.git = {
    signing = {
      key = "3F3207C8D88C3ACC1E91A8C9E38C93040B06B56B";
      # signByDefault = false; # I only want to sign commits, not tags
    };
    settings = {
      commit.gpgsign = true;
    };
  };

  colorScheme = inputs.nix-colors.colorSchemes.material-palenight;

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";

    packages = unstablePkgs ++ stablePkgs ++ jeezyvim;

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      # BROWSER = "firefox";
      # XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
    };
  };
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
