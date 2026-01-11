{
  pkgs,
  lib,
  ...
}: {
  # Only enable on Linux systems where KDE Plasma is available
  config = lib.mkIf pkgs.stdenv.isLinux {
    programs.plasma = {
      enable = true;

      # Virtual Desktops configuration (matching Aerospace workspaces)
      # KDE supports up to 20 desktops, so we'll use 1-9 plus some key letters
      workspace = {
        lookAndFeel = "org.kde.breezedark.desktop";
      };

      # Configure 10 virtual desktops
      configFile = {
        kwinrc = {
          Desktops = {
            Number = 10;
            # Desktop layout based on usage
            Name_1 = "1: Firefox";
            Name_2 = "2: Terminal";
            Name_3 = "3";
            Name_4 = "4";
            Name_5 = "5";
            Name_6 = "6";
            Name_7 = "7";
            Name_8 = "8";
            Name_9 = "9: Spotify";
            Name_10 = "0: General";
          };
        };
      };

      # KWin Effects
      kwin = {
        effects = {
          # Dim inactive windows for better focus visibility
          dimInactive.enable = true;
        };
      };

      # Window rules for automatic app placement removed for now
      # You can configure these manually in:
      # System Settings → Window Management → Window Rules
      #
      # Suggested rules:
      # - Firefox/Chrome → Desktop 1
      # - Kitty → Desktop 2
      # - Spotify → Desktop 9
      # Add other apps to desktops 3-8 as needed

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

          # Switch to virtual desktops (Meh+1-9)
          "Switch to Desktop 1" = "Ctrl+Alt+Shift+1";
          "Switch to Desktop 2" = "Ctrl+Alt+Shift+2";
          "Switch to Desktop 3" = "Ctrl+Alt+Shift+3";
          "Switch to Desktop 4" = "Ctrl+Alt+Shift+4";
          "Switch to Desktop 5" = "Ctrl+Alt+Shift+5";
          "Switch to Desktop 6" = "Ctrl+Alt+Shift+6";
          "Switch to Desktop 7" = "Ctrl+Alt+Shift+7";
          "Switch to Desktop 8" = "Ctrl+Alt+Shift+8";
          "Switch to Desktop 9" = "Ctrl+Alt+Shift+9";
          "Switch to Desktop 10" = "Ctrl+Alt+Shift+0";

          # Move window to virtual desktop (Meh+Meta+1-9)
          # Note: Using Meta instead of Cmd since we're on Linux
          "Window to Desktop 1" = "Ctrl+Alt+Shift+Meta+1";
          "Window to Desktop 2" = "Ctrl+Alt+Shift+Meta+2";
          "Window to Desktop 3" = "Ctrl+Alt+Shift+Meta+3";
          "Window to Desktop 4" = "Ctrl+Alt+Shift+Meta+4";
          "Window to Desktop 5" = "Ctrl+Alt+Shift+Meta+5";
          "Window to Desktop 6" = "Ctrl+Alt+Shift+Meta+6";
          "Window to Desktop 7" = "Ctrl+Alt+Shift+Meta+7";
          "Window to Desktop 8" = "Ctrl+Alt+Shift+Meta+8";
          "Window to Desktop 9" = "Ctrl+Alt+Shift+Meta+9";
          "Window to Desktop 10" = "Ctrl+Alt+Shift+Meta+0";

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
