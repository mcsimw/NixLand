{ disks ? [ "/dev/sdb" ], ... }: {
  disko.devices = {
    disk = {
      x = {
        type = "disk";
	device = builtins.elemAt disks 0;
	type = "disk";
	content = {
	  type = "table";
	  format = "gpt";
	  partitions = [
	    {
	      name = "test";
	      start = "1MiB";
	      end = "100%";
	      part-type = "primary";
	      content = {
	        type = "filesystem";
		format = "ext4";
		mountpoint = "/mnt/d";
	      };
	    }
	  ];
	};
      };
    };
  };
}
