{
  den.aspects.claudeCode.homeManager = { pkgs, ... }: {
    programs.claude-code = {
      enable = true;

      # Gives Claude Code live nixpkgs/option lookups instead of relying on
      # its training data, which lags behind nixpkgs by months.
      mcpServers.nixos = {
        type = "stdio";
        command = "${pkgs.mcp-nixos}/bin/mcp-nixos";
      };
    };
  };
}
