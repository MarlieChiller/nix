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

      # Configure 5 virtual desktops (minimal setup)
      configFile = {
        kwinrc = {
          Desktops = {
            Number = 5;
            # Desktop layout based on usage
            Name_1 = "1: Browser";
            Name_2 = "2: Terminal/Code";
            Name_3 = "3: Communication";
            Name_4 = "4: Media";
            Name_5 = "5: General";
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

      # Window rules for automatic app placement (5-workspace minimal setup)
      window-rules = [
        # Desktop 1: Browser
        {
          description = "Firefox to Desktop 1";
          match = {
            window-class = {
              value = "firefox";
              type = "substring";
            };
          };
          apply = {
            desktops = {
              value = "1";
              apply = "initially";
            };
          };
        }
        {
          description = "Chrome to Desktop 1";
          match = {
            window-class = {
              value = "chrome";
              type = "substring";
            };
          };
          apply = {
            desktops = {
              value = "1";
              apply = "initially";
            };
          };
        }

        # Desktop 2: Terminal/Code
        {
          description = "Kitty to Desktop 2";
          match = {
            window-class = {
              value = "kitty";
              type = "substring";
            };
          };
          apply = {
            desktops = {
              value = "2";
              apply = "initially";
            };
          };
        }
        {
          description = "VSCode to Desktop 2";
          match = {
            window-class = {
              value = "code";
              type = "substring";
            };
          };
          apply = {
            desktops = {
              value = "2";
              apply = "initially";
            };
          };
        }

        # Desktop 3: Communication
        {
          description = "Discord to Desktop 3";
          match = {
            window-class = {
              value = "discord";
              type = "substring";
            };
          };
          apply = {
            desktops = {
              value = "3";
              apply = "initially";
            };
          };
        }
        {
          description = "Slack to Desktop 3";
          match = {
            window-class = {
              value = "slack";
              type = "substring";
            };
          };
          apply = {
            desktops = {
              value = "3";
              apply = "initially";
            };
          };
        }

        # Desktop 4: Media
        {
          description = "Spotify to Desktop 4";
          match = {
            window-class = {
              value = "spotify";
              type = "substring";
            };
          };
          apply = {
            desktops = {
              value = "4";
              apply = "initially";
            };
          };
        }

        # Desktop 5: General (Obsidian and everything else)
        {
          description = "Obsidian to Desktop 5";
          match = {
            window-class = {
              value = "obsidian";
              type = "substring";
            };
          };
          apply = {
            desktops = {
              value = "5";
              apply = "initially";
            };
          };
        }
      ];

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

          # Switch to virtual desktops (Meh+1-5)
          "Switch to Desktop 1" = "Ctrl+Alt+Shift+1";
          "Switch to Desktop 2" = "Ctrl+Alt+Shift+2";
          "Switch to Desktop 3" = "Ctrl+Alt+Shift+3";
          "Switch to Desktop 4" = "Ctrl+Alt+Shift+4";
          "Switch to Desktop 5" = "Ctrl+Alt+Shift+5";

          # Move window to virtual desktop (Meh+Meta+1-5)
          # Note: Using Meta instead of Cmd since we're on Linux
          "Window to Desktop 1" = "Ctrl+Alt+Shift+Meta+1";
          "Window to Desktop 2" = "Ctrl+Alt+Shift+Meta+2";
          "Window to Desktop 3" = "Ctrl+Alt+Shift+Meta+3";
          "Window to Desktop 4" = "Ctrl+Alt+Shift+Meta+4";
          "Window to Desktop 5" = "Ctrl+Alt+Shift+Meta+5";

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
