{
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
}
