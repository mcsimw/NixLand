{ inputs, ... }:
{ pkgs, lib, config, ... }: {
  nixpkgs.config.allowUnfree = true;
  nix = {
    package = pkgs.nixUnstable;
    nixPath = lib.singleton config.nix.settings.nix-path;
    allowed-users = lib.mapAttrsToList (_: u: u.name)
      (lib.filterAttrs (_: user: user.isNormalUser) config.users.users);
    http-connections = 0;
    max-substitution-jobs = 128;
    registery.nixpkgs.flake = inputs.nixpkgs;
    nix-path = "nixpkgs=flake:nixpkgs";
    use-cgroup = true;
    auto-allocate-uids = true;
    builders-use-substitutes = true;
    warn-dirty = false;
    trusted-users = [ "@wheel" ];
    channel.enable = false;
    settings = {
      experimental-features =
        [ "nix-command" "flakes" "cgroups" "auto-allocate-uids" "repl-flake" ];
      substituters = [ "https://nix-community.cachix.org" ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
}
