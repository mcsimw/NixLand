{ inputs, ... }:

{
  flake.nixosModules = {
    inextricable-audio = import ./audio.nix;
    inextricable-boot = import ./boot.nix;
    inextricable-filesystem = import ./filesystem.nix;
    inextricable-lang = import ./lang.nix;
    inextricable-networking = import ./networking.nix;
    inextricable-nix-nixpkgs = import ./nix-nixpkgs.nix { inherit inputs; };
    inextricable-security = import ./security.nix;
    inextricable-time = import ./time.nix;
    inextricable-universal = import ./universal.nix;
    inextricable-usersettings = import ./usersettings.nix;
  };
}
