{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/mcsimw/.config/sops/age/keys.txt";
  };
  environment.persistence."/mnt/c/persistent" = { 
    hideMounts = true; 
    users.mcsimw = {
      directories = [
        { directory = ".gnupg"; mode = "0700"; }
        { directory = ".ssh"; mode = "0700"; }
        ".config/sops/age"
      ];
    };
  };

  services = {
    zfs.autoScrub.enable = true;
    openssh.enable = true;
    dbus.enable = true;
    earlyoom.enable = true;
  };

  programs.nixvim = {
    enable = true;
    extraPlugins = [ pkgs.vimPlugins.modus-themes-nvim];
    colorscheme = "modus";
    plugins.treesitter.enable = true;
  };

  zramSwap.enable = true;

  nixpkgs.config.allowUnfree = true;
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      substituters = [ 
        "https://nix-community.cachix.org"  # nix-community
        "https://cache.iog.io" # haskell
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" # nix-community
	"hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=" # haskell
      ];
    };
  };

  boot = {
    tmp.cleanOnBoot = true;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "failbox";
    firewall.enable = false;
    hostId = "dc44142f";
  };

  time.timeZone = "Canada/Eastern";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
  #  font = "Lat2-Terminus16";
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
	uid = 1000;
      };
    };
  };


  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config = {
      dwl = {
        default = [ "wlr" "gtk" ];
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
      };
    };
  };

  programs = {
    git.enable = true;
    tmux.enable = true;
    steam.enable = true;
  };

  environment.systemPackages = with pkgs; [ age parted wget dwl bemenu foot ];

  security = {
    polkit.enable = true;
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
    emacs-all-the-icons-fonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    corefonts
    vistafonts
    spleen
    terminus_font
  ];

  system.stateVersion = "24.05";
}
