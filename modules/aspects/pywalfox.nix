{
  den.aspects.pywalfox = {
    homeManager = { pkgs, lib, ... }: {
      home.activation.pywalfox = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        ${pkgs.pywalfox-native}/bin/pywalfox install
        mkdir -p "$HOME/.thunderbird/native-messaging-hosts"
        ln -sf "$HOME/.mozilla/native-messaging-hosts/pywalfox.json" \
               "$HOME/.thunderbird/native-messaging-hosts/pywalfox.json"
      '';
    };
  };
}
