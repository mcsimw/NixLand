{ configs, pkgs, ...}:

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
    emacs = {
      enable = true;
      package = pkgs.emacsPgtkGcc;
    };
  };

  services = {
    emacs = {
      enable = true;
      package = pkgs.emacsPgtkGcc;
    };
  };
}
