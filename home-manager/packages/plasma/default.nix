{
  pkgs,
  lib,
  ...
}: {
  # Only enable on Linux systems where KDE Plasma is available
  config = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    programs.plasma = {
      enable = true;

      kwin = {
        # KWin Effects
        effects = {
          # Dim inactive windows for better focus visibility
          dimInactive.enable = true;
        };

        virtualDesktops.names = map toString (lib.range 1 9);
      };

      # Doubles as a media server: never sleep, just dim and blank the screens
      powerdevil.AC = {
        autoSuspend.action = "nothing";
        dimDisplay.idleTimeout = 300;
        turnOffDisplay.idleTimeout = 600;
      };

      # Polonium was tried for Aerospace-style auto-tiling; stock KWin quick
      # tiling is simpler and leaves games alone. Disabled explicitly because
      # plasma-manager doesn't remove keys it no longer manages.
      configFile.kwinrc.Plugins.poloniumEnabled = false;

      # KRunner as the Alfred equivalent (default shortcut Alt+Space), centred
      krunner = {
        position = "center";
        activateWhenTypingOnDesktop = true;
        historyBehavior = "enableSuggestions";
      };

      # Plugins not covered by plasma-manager options; IDs are the plugin file names
      configFile.krunnerrc.Plugins = {
        krunner_appstreamEnabled = false; # Discover packages, unused on NixOS
        krunner_katesessionsEnabled = false; # Kate isn't used
        krunner_konsoleprofilesEnabled = false; # Kitty is the terminal
      };

      # Keyboard shortcuts stay at KDE defaults apart from these
      shortcuts = {
        kwin =
          {
            # Vim-style tiling alongside the default Meta+arrows
            "Window Quick Tile Left" = ["Meta+H" "Meta+Left"];
            "Window Quick Tile Bottom" = ["Meta+J" "Meta+Down"];
            "Window Quick Tile Top" = ["Meta+K" "Meta+Up"];
            "Window Quick Tile Right" = ["Meta+L" "Meta+Right"];

            "Window Maximize" = ["Meta+F" "Meta+PgUp"];
            # Clear the stale Ctrl+Alt+Shift+F from the old Meh layer (KDE default is unbound)
            "Window Fullscreen" = [];
          }
          # Leftovers from the removed Polonium script, which still hold Meta+HJKL
          // lib.genAttrs [
            "PoloniumActivateAbove"
            "PoloniumActivateBelow"
            "PoloniumActivateLeft"
            "PoloniumActivateRight"
            "PoloniumCycleEngine"
            "PoloniumPlaceAbove"
            "PoloniumPlaceBelow"
            "PoloniumPlaceLeft"
            "PoloniumPlaceRight"
            "PoloniumResizeDown"
            "PoloniumResizeLeft"
            "PoloniumResizeRight"
            "PoloniumResizeUp"
            "PoloniumRotateLayout"
            "PoloniumSwitchMonocle"
            "PoloniumToggleActiveTiling"
            "PoloniumToggleSettingsMenu"
          ] (_: []);

        # Stale Meta+A from the old setup (KDE default is unbound)
        plasmashell."next activity" = [];

        # Free Meta+L from screen lock; the dedicated Screensaver key still works
        ksmserver."Lock Session" = "Screensaver";
      };
    };
  };
}
