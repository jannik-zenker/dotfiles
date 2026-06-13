# Installs networkmanager with iwd backend (modern WLAN stack)
{
  den.aspects.networkManager = {
    nixos = {
      networking.networkmanager = {
        enable = true;
        wifi.backend = "iwd";
      };
    };
  };
}
