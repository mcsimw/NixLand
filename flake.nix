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
  };

  outputs = inputs@{ self, nixpkgs, home-manager, disko, ... }: {
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
            };
	  }
	  disko.nixosModules.disko
	  ./disko-config.nix
	  {
	    _module.args.disks = [ "/dev/sdb" ];
	  }

        ];
      };
    };
  };
}
