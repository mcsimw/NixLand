{ inputs, ... }: {
  flake.nixosConfigurations = {
    iso = nixpkgs.lib.nixosSystem { modules = [ ./iso/configuration.nix ]; };
    failbox = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./compootuers/failbox/configuration.nix
        home-manager.nixosModules.home-manager
        {
          programs.tmux.enable = true;
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.mcsimw = import ./compootuers/failbox/home.nix;
          };
          nixpkgs.overlays =
            [ emacs-overlay.overlay neovim-nightly-overlay.overlay ];
        }
        disko.nixosModules.disko
        sops-nix.nixosModules.sops
        nixvim.nixosModules.nixvim
        impermanence.nixosModules.impermanence
        ./compootuers/failbox/disko-config.nix
      ];
    };
  };
}
