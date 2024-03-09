{ config, lib, pkgs, modulesPath, ... }:

{

  boot = {
    initrd = {
      availableKernelModules =
        [ "ata_piix" "ohci_pci" "ehci_pci" "ahci" "sd_mod" "sr_mod" ];
      systemd = {
        enable = true;
        services.rollback = {
          description = "Rollback root filesystem to a pristine state on boot";
          wantedBy = [
            # "zfs.target"
            "initrd.target"
          ];
          after = [ "zfs-import-nixos_pool.service" ];
          before = [ "sysroot.mount" ];
          path = with pkgs; [ zfs ];
          unitConfig.DefaultDependencies = "no";
          serviceConfig.Type = "oneshot";
          script = ''
            zfs rollback -r nixos_pool/faketmpfs_dataset@blank_dataset && echo "  >> >> rollback complete << <<"
          '';
        };
      };
    };
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  };

  fileSystems = {
    "/".neededForBoot = true;
    "/mnt/c".neededForBoot = true;
    "/persist".neededForBoot = true;
  };

  networking = {
    useNetworkd = true;
    useDHCP = true;
  };

  services = {
    resolved.enable = true;
    timesyncd.enable = true;
  };


  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  virtualisation.virtualbox.guest.enable = true;
  hardware.opengl.enable = true;

  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    suspend-then-hibernate.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };
}
