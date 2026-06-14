# Enables zswap to compress data and store it to ram before using the swap part/file
{
  den.aspects.zswap = {
    nixos = {
      boot.kernelParams = [
        "zswap.enabled=1"
        "zswap.compressor=lz4"
        "zswap.max_pool_percent=20"
        "zswap.shrinker_enabled=1"
      ];
    };
  };
}
