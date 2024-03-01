{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = { url = "github:nix-community/impermanence"; };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nixvim.url = "github:nix-community/nixvim";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, disko, emacs-overlay
    , impermanence, treefmt-nix, systems, flake-parts, neovim-nightly-overlay
    , ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      flake = {
        nixosConfigurations = {
          failbox = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              ./compootuers/failbox/configuration.nix
              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.mcsimw = import ./compootuers/failbox/home.nix;
                };
                nixpkgs.overlays =
                  [ emacs-overlay.overlay neovim-nightly-overlay.overlay ];
              }
              disko.nixosModules.disko
              impermanence.nixosModules.impermanence
              ./compootuers/failbox/disko-config.nix
            ];
          };
        };
      };
    };
}
