{
  config,
  pkgs,
  ...
}: let
  # Python kitten: runs inside kitty's own process, applies a random theme
  # via the documented remote-control API. Avoids the listen_on socket and
  # any PATH/env issues from GUI launchers.
  randomThemeKitten = pkgs.writeText "random-theme.py" ''
    import os
    import random
    import traceback
    from kitty.boss import Boss
    from kittens.tui.handler import result_handler

    THEMES_DIR = "${pkgs.kitty-themes}/share/kitty-themes/themes"
    LOG = "/tmp/kitty-random-theme.log"

    def _log(msg):
        try:
            with open(LOG, "a") as f:
                f.write(msg + "\n")
        except Exception:
            pass

    def main(args):
        return None

    @result_handler(no_ui=True)
    def handle_result(args, answer, target_window_id, boss):
        try:
            themes = [f for f in os.listdir(THEMES_DIR) if f.endswith(".conf")]
            if not themes:
                _log("no themes found in " + THEMES_DIR)
                return
            theme = random.choice(themes)
            path = os.path.join(THEMES_DIR, theme)
            w = boss.window_id_map.get(target_window_id)
            _log(f"applying {theme} to window={w!r}")
            boss.call_remote_control(w, ("set-colors", path))
        except Exception:
            _log("handle_result exception:\n" + traceback.format_exc())
  '';
in {
  programs.kitty = {
    enable = true;
    shellIntegration.enableFishIntegration = true;
    # Font is managed by Stylix (JetBrainsMono Nerd Font Mono)
    settings = {
      # env PATH/USER are set via extraConfig below (multiple `env` directives).
      shell = "${pkgs.fish}/bin/fish";
      editor = "${pkgs.neovim}/bin/nvim";
      confirm_os_window_close = 0;
      dynamic_background_opacity = true;
      enable_audio_bell = true;
      macos_titlebar_color = "background";
      macos_option_as_alt = "no";
      tab_bar_edge = "top";
      mouse_hide_wait = "-1.0";
      window_padding_width = 10;
      background_blur = 0;

      # Performance settings
      sync_to_monitor = true;
      input_delay = 3;

      # Convenience features
      copy_on_select = true;
      strip_trailing_spaces = "smart";
      scrollback_lines = 10000;

      # Directory restoration
      shell_integration = "enabled";

      # Window appearance
      hide_window_decorations = "titlebar-only";
      inactive_text_alpha = 0.8;

      # Search functionality
      search_result_color = "#3E4451";
      search_result_bg_color = "#528BFF";
      search_current_match_color = "#000000";
      search_current_match_bg_color = "#FFD700";
      # Map Nerd Font icon ranges to JetBrainsMono Nerd Font
      symbol_map = let
        nerdFontRanges = [
          "U+23FB-U+23FE"
          "U+2B58"
          "U+E200-U+E2A9"
          "U+E0A0-U+E0A3"
          "U+E0B0-U+E0BF"
          "U+E0C0-U+E0C8"
          "U+E0CC-U+E0CF"
          "U+E0D0-U+E0D2"
          "U+E0D4"
          "U+E700-U+E7C5"
          "U+F000-U+F2E0"
          "U+2665"
          "U+26A1"
          "U+F400-U+F4A8"
          "U+F67C"
          "U+E000-U+E00A"
          "U+F300-U+F313"
          "U+E5FA-U+E62B"
        ];
      in
        (builtins.concatStringsSep "," nerdFontRanges) + " JetBrainsMono Nerd Font Mono";

      # Let macOS handle emoji rendering with system emoji font
      # Emojis will use Apple Color Emoji font automatically
    };

    keybindings = {
      "ctrl+alt+1" = "set_colors ${pkgs.kitty-themes}/share/kitty-themes/themes/Rose-Pine.conf";
      "ctrl+alt+2" = "set_colors ${pkgs.kitty-themes}/share/kitty-themes/themes/Rose-Pine-Dawn.conf";
      "ctrl+alt+3" = "set_colors ${pkgs.kitty-themes}/share/kitty-themes/themes/1984_dark.conf";
      "ctrl+alt+4" = "set_colors ${pkgs.kitty-themes}/share/kitty-themes/themes/1984_light.conf";
      "ctrl+alt+0" = "kitten ${randomThemeKitten}";
    };

    # Zego's MDM sets $USER to the email address after macOS updates; that
    # breaks nix-darwin's set-environment script which expands
    # /etc/profiles/per-user/$USER/bin. Pin USER + PATH at kitty-launch time
    # so downstream shell init (fish foreign-env) sees the correct values.
    extraConfig = ''
      env USER=${config.home.username}
      env PATH=/etc/profiles/per-user/${config.home.username}/bin:${config.home.homeDirectory}/.nix-profile/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
    '';
  };
}
