{
  # Pinned once here; every other flake input declares
  # `inputs.nixpkgs.follows = "nixpkgs"` so the whole input graph evaluates
  # against this single nixpkgs revision instead of each dependency pulling
  # in its own.
  flake-file.inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";
  };
}
