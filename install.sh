sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./compouters/failbox/disko-config.nix && nixos-install --no-root-passwd --flake .#failbox
