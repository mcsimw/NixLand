{ inputs, ... }:

let
  commonProfiles = with inputs.self.nixosModules; [
    profiles-nix-nixpkgs
  ];

  commonHome = [
    inputs.home-manager.nixosModule
    {
      home-manager = {
        useGlobalPkgs = true;
        extraSpecialArgs = { inherit inputs; };
        users.mcsimw = import ../failbox/home.nix;
      };
    }
  ];
  nixosSystemWithDefaults = args:
    (inputs.nixpkgs.lib.nixosSystem ((builtins.removeAttrs args [ "hostName" ])
      // {
        specialArgs = { inherit inputs; } // args.specialArgs or { };
        modules =
          [ ./${args.hostName} { networking = { inherit (args) hostName; }; } ]
          ++ commonProfiles ++ (args.modules or [ ]);
      }));

in {

  flake.nixosConfigurations = {
    iso = inputs.nixpkgs.lib.nixosSystem {
      modules = [ ../iso/configuration.nix ];
    };
    failbox = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./failbox/configuration.nix
        inputs.home-manager.nixosModules.home-manager
        {
          programs.tmux.enable = true;
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.mcsimw = import ./failbox/home.nix;
          };
          nixpkgs.overlays = [
            inputs.emacs-overlay.overlay
            inputs.neovim-nightly-overlay.overlay
          ];
        }
        inputs.disko.nixosModules.disko
        inputs.sops-nix.nixosModules.sops
        inputs.nixvim.nixosModules.nixvim
        inputs.impermanence.nixosModules.impermanence
        ./failbox/disko-config.nix
      ];
    };
  };
}
