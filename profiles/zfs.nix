{
  services.zfs = {
    trim = {
      enabled = true;
      interval = "daily";
    };
    autoScrub = {
      enable = true;
      interval = "daily";
    };
  };
}
