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

      # Keyboard shortcuts for directional window focus
      # Using CapsLock (remapped to Meh: Ctrl+Alt+Shift) + H/J/K/L
      shortcuts = {
        kwin = {
          # Focus window to the left (CapsLock+H)
          "Switch Window Left" = "Ctrl+Alt+Shift+H";
          # Focus window down (CapsLock+J)
          "Switch Window Down" = "Ctrl+Alt+Shift+J";
          # Focus window up (CapsLock+K)
          "Switch Window Up" = "Ctrl+Alt+Shift+K";
          # Focus window to the right (CapsLock+L)
          "Switch Window Right" = "Ctrl+Alt+Shift+L";

          # Optional: Quick tile shortcuts with CapsLock
          # "Quick Tile Window to the Left" = "Ctrl+Alt+Shift+Left";
          # "Quick Tile Window to the Right" = "Ctrl+Alt+Shift+Right";
          # "Maximize Window" = "Ctrl+Alt+Shift+Up";
        };
      };

      # Window decorations - ensure active/inactive distinction is clear
      workspace = {
        # Show desktop widgets on all activities
        lookAndFeel = "org.kde.breezedark.desktop";
      };
    };
  };
}
