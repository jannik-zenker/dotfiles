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

  # Neovim here isn't a host/user/home entity, so it never goes through
  # Den's normal resolution pipeline; this builds it as a standalone package
  # instead, via a one-off "nvf" class (see den.lib.nvf.module below).
  # Consumed by flake/lib/mk-neovim.nix.
  den.lib.nvf.package =
    pkgs: vimAspect: args:
    (inputs.nvf.lib.neovimConfiguration {
      inherit pkgs;
      modules = [ (den.lib.nvf.module vimAspect args) ];
    }).neovim;

  # Turns a normal dendritic `vim`-classed aspect (vimAspect) into an nvf
  # module, by building a one-off forwarding class and resolving it
  # directly.
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

      # Pair the forwarding class with the caller's vim aspect so resolving
      # this runs vimAspect's `vim.*` content through the vim -> nvf.vim
      # forward.
      aspect = {
        includes = [
          vimClass
          (vimAspect args)
        ];
      };

      # den.lib.aspects.resolve is explicitly not a stable public API in
      # Den; used directly here (rather than the normal schema/includes
      # machinery) because this is exactly the "building a custom pipeline
      # stage" case it's meant for.
      nvfModule = den.lib.aspects.resolve "nvf" aspect;
    in
    nvfModule;
}
