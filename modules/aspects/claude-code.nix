{
  den.aspects.claudeCode.homeManager = { pkgs, ... }: {
    programs.claude-code = {
      enable = true;

      mcpServers.nixos = {
        type = "stdio";
        command = "${pkgs.mcp-nixos}/bin/mcp-nixos";
      };
    };
  };
}
