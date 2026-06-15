{
  den.aspects.pywalfox = {
    homeManager = { pkgs, ... }: {
      home.activation.pywalfox = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        ${pkgs.pywalfox-native}/bin/pywalfox install
      '';
    };
  };
}
