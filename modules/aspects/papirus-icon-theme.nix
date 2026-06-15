# Install papirus-icon-theme
{
  den.aspects.papirusIconTheme = {
    nixos = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [ papirus-icon-theme ];
    };

    homeManager = { lib, pkgs, ... }: {
      # This Method installs papirus-icon-theme MUTABLE for theme switchers to work
      # with papirus-icon-themes
      home.activation.copyPapirusIcons = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        _target="$HOME/.local/share/icons/Papirus"
        _version="${pkgs.papirus-icon-theme.version}"
        _marker="$_target/.nix-version"

        if [[ "$(cat "$_marker" 2>/dev/null)" != "$_version" ]]; then
          rm -rf "$_target"
          mkdir -p "$HOME/.local/share/icons"
          cp -r "${pkgs.papirus-icon-theme}/share/icons/Papirus" "$_target"
          chmod -R u+w "$_target"
          echo "$_version" > "$_marker"
        fi
      '';
    };
  };
}
