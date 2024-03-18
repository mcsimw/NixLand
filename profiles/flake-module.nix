{ inputs, ... }:

{
  flake.nixosModules = {
    profiles-nix-nixpkgs = import ./nix-nixpkgs.nix { inherit inputs; };
    profiles-zfs = import ./nix-nixpkgs.nix;
  };
}
