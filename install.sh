sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./compootuers/failbox/disko-config.nix && sudo mkdir -p /mnt/persist/home/mcsimw && sudo chown 1000:100 /mnt/persist/home/mcsimw && sudo chown -R 1000:100 /mnt/mnt/c && sudo nixos-install --no-root-passwd --flake .#failbox
