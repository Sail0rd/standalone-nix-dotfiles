# Standalone Nix + Home-Manager dotfiles
---

## Table of Content
- [System Components](#system-components)
- [NixOS Installation Guide](#nixos-installation-guide)
- [WSL2 Installation Guide](#nixos-wsl2-install)
- [Dotfiles Structure](#dotfiles-structure)

## Nix Installation Guide

Flakes can be built with:
- `$ home-manager switch --flake <path>#<hostname>`
- example `$ home-manager switch --flake .#atlas`

## Installation

First of all, you will need to install nix on your OS
```bash
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon
```

after that you will need to install nixGL and home manager
```bash
nix-env -iA home-manager nixGL
```

then clone this repository
```bash
git clone <repo> ~/.config/Home-manager
```

and build the profile of your choice:
```bash
home-manager switch --flake ~/.config/home-manager/#<profile-name>
```

### Screen locking
Due to issue for nix to use the system underlying PAM libs, it's not possible to manage screenlocking package with nix & home manager, we can only manage the configuration
So you have to install your favorite screen locker package, ensure it has enough PAM privileges, and call it into the config.
As this step is distro specific, I won't give direction.

### Screen Sharing
With SwayWM, screensharing seems to work fine with Slack/discord/browser, but I didn't manage to make hyprland desktop backend to successfully screen share with Slack (discord & teams works fine though)

## Dotfiles Structure

```
.
├── commonPackages
├── desktop
│   ├── hyprland
│   └── sway
├── modules
│   └── home-manager
├── packages
├── profiles
│   └── XPS-15-9530
├── programs
│   ├── alacritty
│   ├── direnv
│   ├── fish
│   ├── fzf
│   ├── git
│   ├── jeezyvim
│   ├── kitty
│   ├── lazygit
│   ├── lsd
│   ├── nix-index
│   ├── rofi
│   ├── starship
│   ├── swaylock
│   ├── taskwarrior
│   ├── typst
│   ├── zathura
│   └── zoxide
└── services
    ├── podman
    └── trackwarrior
```

- `commonPackages` directory that holds the packages common to all profiles
- `desktop` holds all windows-manager related programs/services/configuration
- `modules` contain custom modules used across the dotfiles
- `packages` a set of custom built packages
- `profiles` the entrypoint of the config, directly called by the `flake.nix` file, holds all user/hosts profiles home configuration
- `programs` the configuration of all packages used across the profiles
- `services` some services used across the profiles
