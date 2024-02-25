{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, disko, emacs-overlay, impermanence, nixvim, ... }: {
    nixosConfigurations = {
      failbox = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
	  home-manager.nixosModules.home-manager 
	  {
	    home-manager = {
	      useGlobalPkgs = true;
	      useUserPackages = true;
	      users.mcsimw = import ./home.nix;
	      sharedModules = [
		nixvim.homeManagerModules.nixvim
	      ];
            };
	    nixpkgs.overlays = [ emacs-overlay.overlay ];
	  }
	  disko.nixosModules.disko
	  impermanence.nixosModules.impermanence
#          nixvim.homeManagerModules.nixvim
	  ./disko-config.nix
        ];
      };
    };
  };
}
