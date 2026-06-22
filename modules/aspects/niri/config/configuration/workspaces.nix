{
  den.aspects.niri = { host, ... }: {
    homeManager = {
      xdg.configFile."niri/configuration/workspaces.kdl".text = ''
        workspace "terminal"
        workspace "work"
        workspace "code"
        workspace "gaming"
      ''
      + (
        if (host.name == "reacher") then
          ''
            workspace "browser" {
                open-on-output "LG Electronics 24GM79G 0x0008040D"
            }
            workspace "chat" {
                open-on-output "LG Electronics 24GM79G 0x0008040D"
            }
            workspace "mail" {
                open-on-output "LG Electronics 24GM79G 0x0008040D"
            }
            workspace "music" {
                open-on-output "LG Electronics 24GM79G 0x0008040D"
            }
          ''
        else if (host.name == "sirene") then
          ''
            workspace "browser" {
                open-on-output "Dell Inc. DELL P2725D DB7HRC4"
            }
            workspace "chat" {
                open-on-output "Dell Inc. DELL P2725D DB7HRC4"
            }
            workspace "mail" {
                open-on-output "Dell Inc. DELL P2725D DB7HRC4"
            }
            workspace "music" {
                open-on-output "Dell Inc. DELL P2725D DB7HRC4"
            }
          ''
        else
          ''
            workspace "browser"
            workspace "chat"
            workspace "mail"
            workspace "music"
          ''
      );
    };
  };
}
