# Enables zswap to compress data and store it to ram before using the swap part/file
{
  den.aspects.zswap.nixos = {
    boot.kernelParams = [
      "zswap.enabled=1"
      # lz4 favors speed over compression ratio.
      "zswap.compressor=lz4"
      "zswap.max_pool_percent=20"
      # Reclaim pool memory under pressure instead of only growing it.
      "zswap.shrinker_enabled=1"
    ];
  };
}
