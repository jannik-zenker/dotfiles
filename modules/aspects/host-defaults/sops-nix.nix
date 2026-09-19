{ inputs, ... }: {
  flake-file.inputs = {
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.sopsNix.nixos =
    {
      config,
      host,
      lib,
      ...
    }:
    let
      passwordUsers = (lib.attrNames host.users) ++ [ "root" ];
    in
    {
      imports = [ inputs.sops-nix.nixosModules.sops ];

      # sops derives the host's age key from its ed25519 host key
      services.openssh.generateHostKeys = true;

      sops = {
        validateSopsFiles = true;

        age = {
          # automatically import host SSH key as age key
          sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
        };

        # Get user/root password sops secrets
        secrets = lib.genAttrs (map (name: "${name}-password") passwordUsers) (_: {
          sopsFile = ../../../secrets/${host.name}/passwords.yaml;
          neededForUsers = true;
        });
      };

      # Turn off mutable users since they are managed decleratively via sops
      users.mutableUsers = false;

      # Set passwords for root and users
      users.users = lib.genAttrs passwordUsers (name: {
        hashedPasswordFile = config.sops.secrets."${name}-password".path;
      });
    };
}
