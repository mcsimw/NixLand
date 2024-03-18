{
  networking = {
    useNetworkd = true;
    useDHCP = true;
  };
  services = {
    resolved.enable = true;
  };
}
