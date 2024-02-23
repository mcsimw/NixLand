{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  services.zfs.autoScrub.enable = true;

  nix = {
    package = pkgs.nixUnstable;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="      
      ];
    };
  };

  security.polkit.enable = true;

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

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };


  programs = {
    neovim.enable = true;
    git.enable = true;
    tmux.enable = true;
  };

  environment.systemPackages = with pkgs; [
    parted
    wget
    dwl bemenu foot
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

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    dejavu_fonts
  ];
  system.stateVersion = "24.05";
}
