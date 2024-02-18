{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  services.zfs.autoScrub.enable = true;

  nix = {
    package = pkgs.nixUnstable;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "failbox";
    firewall.enable = false;
    hostId = "dc44142f";
  };

  time.timeZone = "Canada/Eastern";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  users = {
    mutableUsers = false;
    users = {
      root.initialPassword = "1";
      mcsimw = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        initialPassword = "1";
      };
    };
  };

  programs = {
    neovim.enable = true;
    git.enable = true;
    tmux.enable = true;
  };

  environment.systemPackages = with pkgs; [
    wget
  ];

  services.openssh.enable = true;
  
  security = {
    sudo.enable = false;
    doas = {
      enable = true;
      extraRules = [{
        users = [ "mcsimw" ];
        noPass = true;
        keepEnv = true;
      }];
    };
  };

  system.stateVersion = "24.05";
}
