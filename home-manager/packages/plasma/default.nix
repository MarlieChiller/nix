{
  pkgs,
  lib,
  ...
}: {
  # Only enable on Linux systems where KDE Plasma is available
  config = lib.mkIf pkgs.stdenv.isLinux {
    programs.plasma = {
      enable = true;

      # KWin Effects
      kwin = {
        effects = {
          # Dim inactive windows for better focus visibility
          dimInactive.enable = true;
        };
      };


      # Keyboard shortcuts (using CapsLock = Meh = Ctrl+Alt+Shift)
      shortcuts = {
        kwin = {
          # Window focus navigation (vim-style H/J/K/L)
          "Switch Window Left" = "Ctrl+Alt+Shift+H";
          "Switch Window Down" = "Ctrl+Alt+Shift+J";
          "Switch Window Up" = "Ctrl+Alt+Shift+K";
          "Switch Window Right" = "Ctrl+Alt+Shift+L";

          # Fullscreen toggle (Meh+F)
          "Window Fullscreen" = "Ctrl+Alt+Shift+F";

          # Quick tiling shortcuts (optional, commented by default like in Aerospace)
          # "Quick Tile Window to the Left" = "Ctrl+Alt+Shift+Left";
          # "Quick Tile Window to the Right" = "Ctrl+Alt+Shift+Right";
          # "Maximize Window" = "Ctrl+Alt+Shift+Up";

          # Window minimize (close equivalent)
          "Window Close" = "Ctrl+Alt+Shift+Q";
        };
      };
    };
  };
}
