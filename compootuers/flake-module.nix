{ inputs, ... }:

let
  systemInextricables = with inputs.self.nixosModules; [
    inextricable-audio
    inextricable-boot
    inextricable-filesystem
    inextricable-lang
    inextricable-networking
    inextricable-nix-nixpkgs
    inextricable-security
    inextricable-time
    inextricable-universal
    inextricable-usersettings
  ];
  systemGenesis = args:
    (inputs.nixpkgs.lib.nixosSystem ((builtins.removeAttrs args [ "hostName" ])
      // {
        specialArgs = { inherit inputs; } // args.specialArgs or { };
        modules =
          [ ./${args.hostName} { networking = { inherit (args) hostName; }; } ]
          ++ systemInextricables ++ (args.modules or [ ]);
      }));
in {

  flake.nixosConfigurations = {
    iso = inputs.nixpkgs.lib.nixosSystem {
      modules = [ ../iso/configuration.nix ];
    };
    failbox = systemGenesis {
      system = "x86_64-linux";
      hostName = "failbox";
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
        ./failbox/disks/a.nix
      ];
    };
  };
}
