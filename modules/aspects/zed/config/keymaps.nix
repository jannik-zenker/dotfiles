{
  den.aspects.zedEditor = {
    homeManager = {
      programs.zed-editor.userKeymaps = [
        {
          context = "Editor && vim_mode == normal && !VimWaiting";
          bindings = {
            "space e" = "project_panel::ToggleFocus";
            "space g" = "git_panel::ToggleFocus";
            "space t" = "terminal_panel::ToggleFocus";

            "ctrl-left" = "pane::ActivatePrevItem";
            "ctrl-right" = "pane::ActivateNextItem";
            "ctrl-q" = "pane::CloseActiveItem";

            "space s" = "vim::HelixJumpToWord";
          };
        }
        {
          context = "GitPanel";
          bindings = {
            "space g" = "workspace::ToggleRightDock";
          };
        }
        {
          context = "ProjectPanel";
          bindings = {
            "space e" = "workspace::ToggleRightDock";
          };
        }
        {
          context = "Terminal";
          bindings = {
            "space t" = "workspace::ToggleBottomDock";
          };
        }
        {
          context = "Editor && vim_mode == normal && !VimWaiting";
          bindings = {
            up = null;
            down = null;
            left = null;
            right = null;
          };
        }
        {
          context = "ProjectPanel";
          bindings = {
            up = null;
            down = null;
            left = null;
            right = null;
          };
        }
        # Disable arrow keys
      ];
    };
  };
}
