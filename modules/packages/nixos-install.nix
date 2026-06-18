{ ... }:
{
  perSystem = { pkgs, ... }: {
    packages.nixos-install = pkgs.writeShellApplication {
      name = "nixos-install";
      runtimeInputs = with pkgs; [ gum ];
      text = ''
        # Theme
        export GUM_CHOOSE_CURSOR_FOREGROUND="#ff79c6"
        export GUM_CHOOSE_SELECTED_FOREGROUND="#889ac8"
        export GUM_CONFIRM_PROMPT_FOREGROUND="#889ac8"
        export GUM_CONFIRM_SELECTED_FOREGROUND="#000000"
        export GUM_SPIN_SPINNER_FOREGROUND="#ff79c6"
        export GUM_CHOOSE_HEADER_FOREGROUND="#889ac8"

        clear

        gum style \
            --foreground "#889ac8" \
            --border-foreground "#ff79c6" \
            --border double \
            --align center \
            --width 50 \
            --margin "1 0" \
            "NixOS Installer - by Jannik Zenker"

        gum style "Please choose the nixos-configuration you would like to install."
        printf "\n"
        SELECTION=$(gum choose "Hauler" "Reacher" "Sirene" "Abort")

        if [[ "$SELECTION" == "Abort" ]]; then
            gum style --foreground "#889ac8" "Exiting..."
            exit 0
        fi

        SELECTION=$(echo "$SELECTION" | tr '[:upper:]' '[:lower:]')

        gum style --foreground "#ff5555" "WARNING: This action will erase all data on the specified disks!"

        if ! gum confirm "Continue?"; then
            gum style --foreground "#889ac8" "Exiting..."
            exit 1
        fi

        clear

        gum spin --spinner dot --title "Starting in 3..." -- sleep 1
        gum spin --spinner dot --title "Starting in 2..." -- sleep 1
        gum spin --spinner dot --title "Starting in 1..." -- sleep 1

        nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- \
            --mode destroy,format,mount \
            --yes-wipe-all-disks \
            --flake "github:jannik-zenker/dotfiles#''${SELECTION}"

        nixos-install --flake "github:jannik-zenker/dotfiles#''${SELECTION}"
      '';
    };
  };
}
