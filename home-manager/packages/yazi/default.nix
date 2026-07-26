{pkgs, ...}: {
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    shellWrapperName = "yy";

    settings = {
      mgr = {
        show_hidden = true;
        ratio = [
          1
          3
          4
        ];
      };
      preview = {
        max_width = 1000;
        max_height = 1000;
      };
      plugin.prepend_previewers = let
        glowPreviewer = url: {
          inherit url;
          run = "piper -- CLICOLOR_FORCE=1 glow -w=$w -s=dark \"$1\"";
        };
      in
        map glowPreviewer [
          "*.md"
          "*.markdown"
          "*.mdown"
          "*.mkd"
          "*.mkdn"
        ];
    };

    plugins = {
      # `setup = true` emits the require(...):setup() call in init.lua;
      # without it the plugin is linked into place but never loaded.
      full-border = {
        package = pkgs.yaziPlugins.full-border;
        setup = true;
      };
      starship = {
        package = pkgs.yaziPlugins.starship;
        setup = true;
      };
      relative-motions = {
        package = pkgs.yaziPlugins.relative-motions;
        setup = true;
        settings = {
          show_numbers = "relative";
          show_motion = true;
        };
      };

      # Driven by keymap.toml below rather than a setup call.
      smart-enter = pkgs.yaziPlugins.smart-enter;
      jump-to-char = pkgs.yaziPlugins.jump-to-char;

      # Used by the glow markdown previewer above.
      piper = pkgs.yaziPlugins.piper;
    };

    keymap.mgr.prepend_keymap =
      [
        {
          on = "l";
          run = "plugin smart-enter";
          desc = "Enter the child directory, or open the file";
        }
        {
          on = "f";
          run = "plugin jump-to-char";
          desc = "Jump to char";
        }
      ]
      # Digits start a relative motion, e.g. `3k` / `12j`.
      ++ map (n: {
        on = toString n;
        run = "plugin relative-motions ${toString n}";
        desc = "Move in relative steps";
      }) [1 2 3 4 5 6 7 8 9];
  };
}
