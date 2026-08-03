{
  den.aspects.openssh = {
    nixos = {
      services.openssh = {
        enable = true;
        openFirewall = false; # Do not automatically listen on all interfaces

        settings = {
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          PermitRootLogin = "no";
        };
      };
    };
  };
}
