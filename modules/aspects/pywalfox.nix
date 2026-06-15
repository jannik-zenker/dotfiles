{
  den.aspects.pywalfox = {
    homeManager = { pkgs, lib, ... }: {
      home.activation.pywalfox = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        ${pkgs.pywalfox-native}/bin/pywalfox install
        ${pkgs.pywalfox-native}/bin/pywalfox install --thunderbird
      '';
    };
  };
}
