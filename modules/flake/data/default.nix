{ lib, ... }:
{
  # `flake.data` has no built-in merge support (flake-parts exposes it as a raw
  # freeform attribute), so declare it as an attrsOf-raw option here to let
  # every sibling file in this folder contribute its own key to it via plain
  # `flake.data.<name> = ...`. Unlike `flake.lib`, entries here are plain data
  # tables, not functions.
  options.flake.data = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.raw;
    default = { };
  };
}
