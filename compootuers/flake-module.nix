{ inputs, ... }:

let
  inextricable = with inputs.self.nixosModules; [
    profiles-audio
    profiles-boot
    profiles-filesystem
    profiles-lang
    profiles-networking
    profiles-nix-nixpkgs
    profiles-security
    profiles-time
    profiles-universal
    profiles-usersettings
  ];
  genisis = args:
    (inputs.nixpkgs.lib.nixosSystem ((builtins.removeAttrs args [ "hostName" ])
      // {
        specialArgs = { inherit inputs; } // args.specialArgs or { };
        modules =
          [ ./${args.hostName} { networking = { inherit (args) hostName; }; } ]
          ++ inextricable ++ (args.modules or [ ]);
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
        ./failbox/disks/a.nix
      ];
    };
  };
}
