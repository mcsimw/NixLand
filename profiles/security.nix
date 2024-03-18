{
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
}
