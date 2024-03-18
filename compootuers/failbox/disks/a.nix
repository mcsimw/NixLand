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
              label = "BOOT";
              size = "1G";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            nixos = {
              label = "NIXOS";
              size = "100%";
              content = {
                type = "zfs";
                pool = "nixos";
              };
            };
          };
        };
      };
    };
    zpool = {
      nixos = {
        type = "zpool";
        options = {
          autotrim = "off";
          ashift = "12";
        };
        rootFsOptions = {
          compression = "zstd";
          acltype = "posixacl";
          atime = "off";
          xattr = "sa";
          normalization = "formD";
          mountpoint = "none";
          canmount = "off";
          encryption = "aes-256-gcm";
          keyformat = "passphrase";
          keylocation = "prompt";
          sync = "disabled";
          dnodesize = "auto";
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
          persist = {
            type = "zfs_fs";
            mountpoint = "/persist";
          };
          a = {
            type = "zfs_fs";
            mountpoint = "/mnt/a";
          };
        };
        postCreateHook = "zfs snapshot nixos/faketmpfs@blank";
      };
    };
  };
}
