{ configs, pkgs, ... }:

{
  home = {
    username = "mcsimw";
    homeDirectory = "/home/mcsimw";
    stateVersion = "24.05";
  };
  programs = {
    home-manager.enable = true;
    firefox.enable = true;
    git = {
      enable = true;
      userName = "Maor Haimovitz";
      userEmail = "maor@mcsimw.com";
    };
    neovim.enable = true;
    emacs = {
      enable = true;
      package = pkgs.emacs-pgtk;
    };
  };
}
