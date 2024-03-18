#!/usr/bin/env bash

set -e

cat << Install
This script will format whatever disk is specified in your nixos configuration as the operating system drive. The operating system drive has a standard layout which is defined in a disko template.


Partition 1:
	Size: 1GB
	Filesystem: FAT32
	Flags: EF00
	PartLabel = BOOT
	Mountpoint = /boot
Partition 2:
	Size: The rest of the available storage on the disk
	Filesystem: ZFS
	PartLabel: NIXOS
	Pool Name: nixos
	Pool Flags:
		ashift = will vary depending on drive ( defaults to 12 )
		autotrim =  on
	Pool dataset Flags:
		compression = zstd
		acltype = posixacl
		atime = off
		xattr = sa
		normalization = formD
		mountpoint = none
		encryption = aes-256-gcm
		keyformat = passphrase
		keylocation = prompt
	snapshot : A post create hook will create the blank snapshot faketmpfs@blank
	nixos datasets:
		faketmpfs ( mounted at / with the blank snapshot faketmpfs@blank )
		nix ( mounted at /nix )
		tmp ( mounted at /tmp )
		persist ( mounted at /persist )
		a ( mounted at /mnt/a ) - a persistent dataset that will be used for storing things



Install


# Ask user for hostname
while true; do
	read -rp "Which host to install? (failbox / eldritch / cacodaemoniacal / phantasmagoric): " hostname
	case $hostname in
		failbox|eldritch|cacodaemoniacal|phantasmagoric ) break;;
		* ) echo "Invalid host. Please select a valid host.";;
	esac
done




# Not strictly neccessary but I like to format it my way
perform_formatting() {
	local hostname=$1

	case "$hostname" in
		failbox)
			echo "Performing action for failbox..."
			for ((i = 1; i <= 7; i++)); do
				echo "Attempt $i: Running wipefs -a on /dev/sda..."
				sudo wipefs -a /dev/sda
				if [ "$i" -lt 7 ]; then
					echo "Waiting for 5 seconds before the next attempt..."
					sleep 5
				fi
			done
			echo "Formatting completed. Give me a min to do something :)"
			sleep 5
			;;
		eldritch)
			echo "Performing action for eldritch..."
			for ((i = 1; i <= 7; i++)); do
				echo "Attempt $i: Running nvme format -f on /dev/nvme0n1..."
				nvme format -f /dev/nvme0n1
				if [ "$i" -lt 7 ]; then
					echo "Waiting for 5 seconds before the next attempt..."
					sleep 5
				fi
			done
			echo "Formatting completed. Give me a min to do something :)"
			sleep 60
			;;
		cacodaemoniacal)
			echo "Performing action for cacodaemoniacal..."
			;;
		phantasmagoric)
			echo "Performing action for phantasmagoric..."
			for ((i = 1; i <= 7; i++)); do
				echo "Attempt $i: Running blkdiscard -f on /dev/sda..."
				blkdiscard -f /dev/sda
				if [ "$i" -lt 7 ]; then
					echo "Waiting for 5 seconds before the next attempt..."
					sleep 5
				fi
			done
			echo "Formatting completed. Give me a min to do something :)"
			sleep 60
			;;
	esac
}

perform_formatting "$hostname"


# Partition operating system disk
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko "./compootuers/$hostname/disks/a.nix"

# Set correct premissions
sudo install -o 1000 -g 100 -d /mnt/persist/home/mcsimw && sudo chown -R 1000:100 /mnt/mnt/a

sudo nixos-install --no-root-passwd --flake .#$hostname
