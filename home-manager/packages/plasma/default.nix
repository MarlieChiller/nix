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

      # Keyboard shortcuts are left at KDE defaults on purpose
    };
  };
}
