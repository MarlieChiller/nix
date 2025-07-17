{lib, pkgs, ...}: {
  home.packages = with pkgs; [
    kitty
  ];

  programs.kitty = lib.mkForce {
    enable = true;
    themeFile = "Nord";
    shellIntegration.enableFishIntegration = true;
    font = {
      name = "JetBrainsMono Nerd Font Mono";
      size = 14;
    };
    settings = {
      scrollback_lines = 10000;
      scrollback_pager = "nvim -c 'setlocal nonumber nolist showtabline=0 foldcolumn=0|Man!' -c 'autocmd VimEnter * normal G' -";
      scrollback_pager_history_size = 256;
      confirm_os_window_close = 0;
      dynamic_background_opacity = true;
      enable_audio_bell = true;
      macos_titlebar_color = "background";
      tab_bar_edge = "top";
      mouse_hide_wait = "-1.0";
      window_padding_width = 10;
      # background_opacity = "0.95";
      background_blur = 0;
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
        (builtins.concatStringsSep "," mappings) + " Symbols Nerd Font";
    };
  };
}
