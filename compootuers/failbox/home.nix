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
    foot = {
      enable = true;
      settings = {
        main = {
          term = "xterm-256color";
	  font = "Spleen:size=12";
	};
	colors = {
          background = "000000";
          foreground = "ffffff";
          regular0 = "000000";
          regular1 = "ff8059";
          regular2 = "44bc44";
          regular3 = "d0bc00";
          regular4 = "2fafff";
          regular5 = "feacd0";
          regular6 = "00d3d0";
          regular7 = "bfbfbf";
          bright0 = "595959";
          bright1 = "ef8b50";
          bright2 = "70b900";
          bright3 = "c0c530";
          bright4 = "79a8ff";
          bright5 = "b6a0ff";
          bright6 = "6ae4b9";
          bright7 = "ffffff";
	};
      };
    };
    git = {
      enable = true;
      userName = "Maor Haimovitz";
      userEmail = "maor@mcsimw.com";
    };
    emacs = {
      enable = false;
      # package = pkgs.emacs-pgtk;
    };
  };
}
