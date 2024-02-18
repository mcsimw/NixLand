#!/usr/bin/env bash

echo "Wiping disk"
wipefs -f /dev/sda && sleep 10

echo "Partitioning disk"
parted -a optimal -s /dev/sda \
	unit mib \
	mklabel gpt \
	mkpart bootfs 1 1025 \
	mkpart swapfs 1025 5121 \
	mkpart nixfs 5121MiB 100% \
	set 1 esp on \
	set 2 swap on

echo "Formatting partitions with filesystem"
mkfs.fat -F32 -n BOOT /dev/sda1
mkswap -L SWAP /dev/sda2
zpool create -f \
	-o ashift=12 \
	-o autotrim=on \
	-O compression=zstd \
	-O acltype=posixacl \
	-O atime=off \
	-O xattr=sa \
	-O normalization=formD \
	-O mountpoint=none \
	-O encryption=aes-256-gcm \
	-O keyformat=passphrase \
	-O keylocation=prompt \
	znix /dev/sda3

echo "Creating /"
zfs create -o mountpoint=legacy znix/faketmpfs
zfs create snapshot znix/faketmpfs@blank
mount -t zfs znix/faketmpfs /mnt

echo "Mounting /boot (EFI partition)"
mount --mkdir /dev/sda1 /mnt/boot

echo "Creating /nix"
zfs create -o mountpoint=legacy znix/nix
mount --mkdir -t zfs znix/nix /mnt/nix

echo "Creating /tmp"
zfs create -o mountpoint=legacy znix/tmp
mount --mkdir -t zfs znix/tmp /mnt/tmp
