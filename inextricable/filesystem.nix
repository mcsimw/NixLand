{pkgs, config, ...}:
{
  boot = {
    tmp.cleanOnBoot = true;
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  };
  zramSwap.enable = true;
  services = {
    zfs = {
      trim = {
        enabled = true;
        interval = "daily";
      };
      autoScrub = {
        enable = true;
        interval = "daily";
      };
    };
  };
}
