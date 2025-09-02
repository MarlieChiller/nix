{
  lib,
  pkgs,
  ...
}: {
  programs.kitty = {
    enable = true;
    shellIntegration.enableFishIntegration = true;
    font = lib.mkForce {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrainsMono Nerd Font Mono";
      size = 14;
    };
    settings = {
      shell = "${pkgs.fish}/bin/fish";
      editor = "${pkgs.neovim}/bin/nvim";
      confirm_os_window_close = 0;
      dynamic_background_opacity = true;
      enable_audio_bell = true;
      macos_titlebar_color = "background";
      macos_option_as_alt = "yes";
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

      # Search functionality
      search_result_color = "#3E4451";
      search_result_bg_color = "#528BFF";
      search_current_match_color = "#000000";
      search_current_match_bg_color = "#FFD700";
      symbol_map = let
        mappings = [
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
        (builtins.concatStringsSep "," mappings) + " JetBrainsMono Nerd Font Mono";
    };
    
    keybindings = {
      "ctrl+alt+1" = "set_colors --configured";
      "ctrl+alt+2" = "set_colors --all foreground=#f8f8f2 background=#282a36";
      "ctrl+alt+3" = "set_colors --all foreground=#e0def4 background=#191724";
    };
  };
}
