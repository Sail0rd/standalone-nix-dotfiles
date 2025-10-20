{
  description = "Standalone Nix + Home Manager configuration";

  inputs = {
    nixGL.url = "github:nix-community/nixGL";
    nixGL.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05"; # Use a current stable release

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

    jeezyvim.url = "github:Sail0rd/JeezyVim";
    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs =
    inputs:
    with inputs;
    let
      # Define a system architecture to use (e.g., "x86_64-linux" or "aarch64-darwin")
      system = "x86_64-linux";

      # Overlays and package set
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          permittedInsecurePackages = [ ];
        };
        overlays = [
          nixGL.overlay
          jeezyvim.overlays.default
          # This allow to reference pkgs.stable to install package from stable channel
          (final: prev: {
            stable = import nixpkgs-stable {
              inherit (prev) system;
              config = prev.config;
            };
            minicava = prev.callPackage ./packages/minicava.nix; # add minicava to pkgs attribute
          })
        ];
      };

      argDefaults = {
        inherit inputs self;
        # channels = {
        #   inherit nixpkgs nixpkgs-stable;
        # };
      };

      mkHomeConfiguration =
        {
          system ? "x86_64-linux",
          hostname,
          user,
          email ? "",
          args ? { },
          modules,
        }:
        let
          specialArgs =
            argDefaults
            // {
              inherit
                hostname
                user
                email
                nix-colors
                ;
            }
            // args;
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./profiles/${hostname}/home.nix # all profiles will have their config there
          ]
          ++ modules;
          extraSpecialArgs = specialArgs;
        };

    in
    {
      homeConfigurations = {
        "XPS-15-9530" = mkHomeConfiguration {
          hostname = "XPS-15-9530";
          user = "mathis";
          email = "mguilbaud@hackuity.io";
          modules = [
            hyprland.homeManagerModules.default
            nix-index-database.homeModules.nix-index
            nix-colors.homeManagerModules.default
          ];
        };
      };
    };
}
