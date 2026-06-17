{ inputs, ... }:
{
  flake-file.inputs = {
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.sopsNix = {
    nixos = {
      imports = [ inputs.sops-nix.nixosModules.sops ];

      sops = {
        validateSopsFiles = true;

        age = {
          # automatically import host SSH key as age key
          sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
        };
      };
    };
  };
}
