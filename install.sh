sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./compootuers/failbox/disko-config.nix && sudo nixos-install --no-root-passwd --flake .#failbox
