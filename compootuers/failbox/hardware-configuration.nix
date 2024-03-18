{
  boot = {
    initrd = {
      availableKernelModules =
        [ "ata_piix" "ohci_pci" "ehci_pci" "ahci" "sd_mod" "sr_mod" ];
    };
  };
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
