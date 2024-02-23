{ config, lib, pkgs, modulesPath, ... }:

{

  boot = {
    initrd = {
      availableKernelModules = [ "ata_piix" "ohci_pci" "ehci_pci" "ahci" "sd_mod" "sr_mod" ];
      postDeviceCommands = lib.mkAfter ''
        zfs rollback -r zos/faketmpfs@blank
      '';
    };
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  };

  fileSystem."/".neededForBoot = true;

  #fileSystems = {
  #  "/" = {
  #    device = "znix/faketmpfs";
  #    fsType = "zfs";
  #    neededForBoot = true;
  #  };
  #  "/mnt/c" = {
  #    device = "znix/c";
  #    fsType = "zfs";
  #    neededForBoot = true;
  #  };
  #  "/boot" = {
  #    device = "/dev/sda1";
  #    fsType = "vfat";
  #  };
  #  "/nix" = {
  #    device = "znix/nix";
  #    fsType = "zfs";
  #  };
  #  "/tmp" = {
  #    device = "znix/tmp";
  #    fsType = "zfs";
  #  };
  #};

  #swapDevices =
  #  [ { device = "/dev/sda2"; }
  #  ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  virtualisation.virtualbox.guest.enable = true;
  hardware.opengl.enable = true;
}
