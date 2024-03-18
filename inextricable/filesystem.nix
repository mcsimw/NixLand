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
        enable = true;
        interval = "daily";
      };
      autoScrub = {
        enable = true;
        interval = "daily";
      };
    };
  };
  fileSystems = {
    "/".neededForBoot = true;
    "/mnt/a".neededForBoot = true;
    "/persist".neededForBoot = true;
  };
  boot.initrd.systemd.services.rollback = {
    description = "Rollback root filesystem to a pristine state on boot";
    wantedBy = [
      "initrd.target"
    ];
    after = [ "zfs-import-nixos.service" ];
    before = [ "sysroot.mount" ];
    path = with pkgs; [ zfs ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = ''
      zfs rollback -r nixos/faketmpfs@blank && echo "  >> >> rollback complete << <<"
    '';
  };
}
