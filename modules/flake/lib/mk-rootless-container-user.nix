{ ... }:
{
  # Creates a rootless system user + group for running a rootless OCI
  # container (podman), including the subuid/subgid ranges podman needs to
  # map container-internal uids. Merge the result into a NixOS config, e.g.:
  #   self.lib.mkRootlessContainerUser {
  #     name = "foundry";
  #     id = 300;
  #     subIdStart = 165536;
  #   }
  config.flake.lib.mkRootlessContainerUser =
    {
      name,
      id,
      subIdStart,
      subIdCount ? 65536,
      home ? "/var/lib/${name}",
    }:
    {
      users.groups.${name}.gid = id;

      users.users.${name} = {
        isSystemUser = true;
        uid = id;
        group = name;
        linger = true;

        inherit home;
        createHome = true;

        subUidRanges = [
          {
            startUid = subIdStart;
            count = subIdCount;
          }
        ];

        subGidRanges = [
          {
            startGid = subIdStart;
            count = subIdCount;
          }
        ];
      };
    };
}
