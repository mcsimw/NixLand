{ inputs, ... }:

{
  flake.nixosModules = {
    profiles-audio = import ./audio.nix;
    profiles-boot = import ./boot.nix;
    profiles-filesystem = import ./filesystem.nix;
    profiles-lang = import ./lang.nix;
    profiles-networking = import ./networking.nix;
    profiles-nix-nixpkgs = import ./nix-nixpkgs.nix { inherit inputs; };
    profiles-security = import ./security.nix;
    profiles-time = import ./time.nix;
    profiles-universal = import ./universal.nix;
    profiles-usersettings = import ./usersettings.nix;
  };
}
