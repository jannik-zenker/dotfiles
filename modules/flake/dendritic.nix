# Bootstraps the dendritic pattern this repo relies on: flake-file's module
# lets flake.nix's `inputs` be declared from any file under modules/ (see
# `flake-file.inputs` below), and den's own dendritic module recursively
# imports Den's modules/ tree, registering every den.* option (den.hosts,
# den.aspects, den.schema, ...) so the rest of this repo can use them without
# further wiring.
{ inputs, ... }: {
  flake-file.inputs = {
    den.url = "github:denful/den";
    flake-file.url = "github:vic/flake-file";
  };

  imports = [
    inputs.flake-file.flakeModules.dendritic
    inputs.den.flakeModules.dendritic
  ];
}
