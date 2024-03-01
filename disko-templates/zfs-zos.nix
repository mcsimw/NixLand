{
  disko.devices = {
    disk = {
      nixos = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            bootfs = {
              type = "EF00";
              size = "1G";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            nixosfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zos";
              };
            };
          };
        };
      };
    };
    zpool = {
      zos = {
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
          canmount = "off";
          sync = "disabled";
        };
        datasets = {
          faketmpfs = {
            type = "zfs_fs";
            mountpoint = "/";
          };
          nix = {
            type = "zfs_fs";
            mountpoint = "/nix";
          };
          tmp = {
            type = "zfs_fs";
            mountpoint = "/tmp";
          };
          c = {
            type = "zfs_fs";
            mountpoint = "/mnt/c";
          };
        };
        postCreateHook = "zfs snapshot zos/faketmpfs@blank";
      };
    };
  };
}