{
  pkgs,
  inputs,
  ...
}: let
  yazi-plugins = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "3d1efb706924112daed986a4eef634e408bad65e";
    sha256 = "sha256-GgEg1A5sxaH7hR1CUOO9WV21kH8B2YUGAtOapcWLP7Y=";
  };
in {
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
      plugin.prepend_previewers = [
        {
          name = "*.md";
          run = "piper -- CLICOLOR_FORCE=1 glow -w=$w -s=dark \"$1\"";
        }
        {
          name = "*.markdown";
          run = "piper -- CLICOLOR_FORCE=1 glow -w=$w -s=dark \"$1\"";
        }
        {
          name = "*.mdown";
          run = "piper -- CLICOLOR_FORCE=1 glow -w=$w -s=dark \"$1\"";
        }
        {
          name = "*.mkd";
          run = "piper -- CLICOLOR_FORCE=1 glow -w=$w -s=dark \"$1\"";
        }
        {
          name = "*.mkdn";
          run = "piper -- CLICOLOR_FORCE=1 glow -w=$w -s=dark \"$1\"";
        }
      ];
    };

    plugins = {
      full-border = "${pkgs.yaziPlugins.full-border}";
      smart-enter = "${pkgs.yaziPlugins.smart-enter}";
      starship = "${pkgs.yaziPlugins.starship}";
      jump-to-char = "${pkgs.yaziPlugins.jump-to-char}";
      relative-motions = "${pkgs.yaziPlugins.relative-motions}";
      piper = "${yazi-plugins}/piper.yazi";
    };
  };
}
