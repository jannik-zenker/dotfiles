{
  den.aspects.zedEditor = {
    homeManager = {
      programs.zed-editor = {
        # Turn off imperative settings
        mutableUserSettings = false;
        userSettings = {
          #--- General Settings ---#
          # Get rid of "Trust this project?" window
          session = {
            trust_all_worktrees = true;
          };

          # Close zed when no buffer is open
          when_closing_with_no_tabs = "close_window";

          # Turn off telemetry
          telemetry = {
            diagnostics = false;
            metrics = false;
            anthropic_retention = false;
          };

          #--- Theming ---#
          icon_theme = {
            mode = "light";
            light = "Base Charmed Icons";
            dark = "Base Charmed Icons";
          };

          theme = {
            mode = "light";
            light = "Tokyo Night Moon";
            dark = "Tokyo Night";
          };

          # Enable italic comments
          theme_overrides = {
            "Tokyo Night" = {
              syntax.comment.font_style = "italic";
              "comment.doc".font_style = "italic";
            };

            "Tokyo Night Moon" = {
              syntax.comment.font_style = "italic";
              "comment.doc".font_style = "italic";
            };
          };

          #--- UI Elements ---#
          # Hide bottom bar
          status_bar."experimental.show" = false;
          toolbar.quick_actions = false;

          # File-tree
          project_panel = {
            default_width = 400;
            hide_root = true;
            auto_fold_dirs = false;
            sticky_scroll = false;
            scrollbar.show = "never";
            indent_guides.show = "never";
          };

          # Outline-panel
          outline_panel = {
            default_width = 300;
            indent_guides.show = "never";
          };

          # File-finder
          file_finder.modal_max_width = "small";

          # Scroll bar
          scrollbar.show = "never";

          # Font settings
          ui_font_size = 18;
          ui_font_family = "MonaspiceNe Nerd Font Mono";

          #--- Editor ---#
          buffer_font_family = "MonaspiceNe Nerd Font Mono";
          buffer_font_size = 18;
          gutter.min_line_number_digits = 0;
          vim_mode = true;
          cursor_blink = false;
          # Disable highlighting similar matches
          selection_highlight = false;
          drag_and_drop_selection.enabled = false;
          seed_search_query_from_cursor = "never";
          current_line_highlight = "none";
          show_whitespaces = "none";
          tab_size = 4;
          auto_indent = true;
          auto_indent_on_paste = true;
          # Hide code actions icon
          inline_code_actions = false;
          format_on_save = "on";
          extend_comment_on_newline = false;
          horizontal_scroll_margin = 1;
          vertical_scroll_margin = 1;
          diagnostics = {
            include_warnings = true;
            inline.enabled = true;
          };
          soft_wrap = "editor_width";

          #--- Agent window ---#
          agent_buffer_font_family = "MonaspiceNe Nerd Font Mono";
          agent_buffer_font_size = 18;
        };
      };
    };
  };
}
