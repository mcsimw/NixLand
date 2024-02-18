{ configs, pkgs, ...}:

{
  home = {
    username = "mcsimw";
    homeDirectory = "/home/mcsimw";
    stateVersion = "24.05";
  };
  programs.home-manager.enable = true;
}
