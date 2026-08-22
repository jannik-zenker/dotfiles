{
  den,
  inputs,
  lib,
  ...
}:
{
  flake-file.inputs.nvf = {
    url = "github:notashelf/nvf";
  };

  # Function to generate a nvf configuration
  den.lib.nvf.package =
    pkgs: vimAspect: args:
    (inputs.nvf.lib.neovimConfiguration {
      inherit pkgs;
      modules = [ (den.lib.nvf.module vimAspect args) ]; # Uses funtion den.lib.module for module import
    }).neovim;

  # Helper-Function to generate nvf modules from dendritic aspects
  den.lib.nvf.module =
    vimAspect: args:
    let
      # a custom `vim` class that forwards to class `nvf.vim`
      vimClass =
        { aspect-chain }:
        den.batteries.forward {
          each = lib.singleton true;
          fromClass = _: "vim";
          intoClass = _: "nvf";
          intoPath = _: [ "vim" ];
          fromAspect = _: lib.head aspect-chain;
          adaptArgs = lib.id;
        };

      # Redefine aspect by applying the vimClass forward to vimAspect
      aspect = {
        includes = [
          vimClass
          (vimAspect args)
        ];
      };

      # Resolve all contributions to class `nvf` from the aspect graph
      # into a Nix module containing the resulting imports.
      nvfModule = den.lib.aspects.resolve "nvf" aspect;
    in
    nvfModule;
}
