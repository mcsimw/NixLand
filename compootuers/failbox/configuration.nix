{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];


  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/mcsimw/.config/sops/age/keys.txt";
  };
  environment.persistence."/persist" = {
    hideMounts = true;
    users.mcsimw = {
      directories = [
        {
          directory = ".gnupg";
          mode = "0700";
        }
        {
          directory = ".ssh";
          mode = "0700";
        }
        ".config/sops/age"
      ];
    };
  };

  services = {
    openssh.enable = true;
    dbus.enable = true;
    earlyoom.enable = true;
  };

  programs.nixvim = {
    enable = true;
    extraPlugins = [ pkgs.vimPlugins.modus-themes-nvim ];
    colorscheme = "modus";
    plugins.treesitter.enable = true;
    options = {
      number = true;
      relativenumber = true;
    };
  };


  networking = {
    firewall.enable = false;
    hostId = "dc44142f";
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

}
