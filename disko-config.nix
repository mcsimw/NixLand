{ disks ? [ "/dev/sdb" ], ... }: {
  disko.devices = {
    disk = {
      lemon = {
        device = builtins.elemAt disks 0;
        content = {
          type = "gpt";
          partitions = {
            LEMON = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "xfs";
                mountpoint = "/mnt/d";
              };
            };
          };
        };
      };
    };
  };
}
