{
  disko.devices = {
    disk = {
      sda = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              type = "EF00";
	      label = "BOOT_LABEL";
              size = "1G";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            nixos = {
	      label = "NIXOS_LABEL"
              size = "100%";
              content = {
                type = "zfs";
                pool = "nixos_pool";
              };
            };
          };
        };
      };
    };
    zpool = {
      nixos_pool = {
        type = "zpool";
        options = {
          autotrim = "on";
          ashift = "12";
        };
        rootFsOptions = {
          compression = "zstd";
          acltype = "posixacl";
          atime = "off";
          xattr = "sa";
          normalization = "formD";
          mountpoint = "none";
          encryption = "aes-256-gcm";
          keyformat = "passphrase";
          keylocation = "prompt";
        };
        datasets = {
          faketmpfs_dataset = {
            type = "zfs_fs";
            mountpoint = "/";
          };
          nix_dataset = {
            type = "zfs_fs";
            mountpoint = "/nix";
          };
          tmp_dataset = {
            type = "zfs_fs";
            mountpoint = "/tmp";
          };
          c_dataset = {
            type = "zfs_fs";
            mountpoint = "/mnt/c";
          };
        };
        postCreateHook = "zfs snapshot nixos_pool/faketmpfs_dataset@blank_dataset";
      };
    };
  };
}
