{
  disko.devices = {
    disk = {
      sdb = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
	    BOOT = {
	      size = "1G";
	      type = "EF00";
	      content = {
	        type = "EF00";
		content = {
		  type = "filesystem";
		  format = "vfat";
		  mountpoint = "/boot";
		};
	      };
	    };
            OS = {
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
	  acltype= "posixacl";
	  atime = "off";
	  xattr = "sa";
	  normalization = "formD";
	  mountpoint = "none";
	  encryption = "aes-256-gcm";
	  keyformat = "passphrase";
	  keyformat = "passphrase";
	  keylocation = "prompt";
        };
        datasets = {
          faketmpfs = {
            type = "zfs_fs";
	    options.mountpoint = "legacy";
            mountpoint = "/";
          };
          nix = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/nix";
          };
          tmp = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/tmp";
          };
          c = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/mnt/c";
          };
        };
        postCreateHook = "zfs snapshot zos@faketmpfs@blank";
      };
    };
  };
}
