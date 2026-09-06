{ lib, ... }:
{
  # `flake.lib` has no built-in merge support (flake-parts exposes it as a raw
  # freeform attribute), so declare it as an attrsOf-raw option here to let
  # every sibling file in this folder contribute its own key to it via plain
  # `flake.lib.<name> = ...`.
  options.flake.lib = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.raw;
    default = { };
  };
}
