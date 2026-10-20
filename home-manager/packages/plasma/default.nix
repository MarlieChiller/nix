{
  pkgs,
  lib,
  ...
}: let
  # Mirror Aerospace on macOS: Meh (Ctrl+Alt+Shift, CapsLock via keyd or the
  # Moonlander Meh key) drives focus/workspaces, Hyper (Meh+Meta, i.e. Meh+Cmd)
  # moves windows.
  meh = "Ctrl+Alt+Shift";
  hyper = "Meta+Ctrl+Alt+Shift";

  # With Shift held, Qt can report a number key as its shifted glyph (1 -> !),
  # so bind both spellings. Glyphs assume the US layout set in
  # system/nixos/configuration.nix.
  shifted = ["!" "@" "#" "$" "%" "^" "&" "*" "("];
  workspaceShortcuts = lib.listToAttrs (lib.concatLists (lib.imap1 (n: glyph: let
      num = toString n;
    in [
      (lib.nameValuePair "Switch to Desktop ${num}" ["${meh}+${num}" "Ctrl+Alt+${glyph}"])
      (lib.nameValuePair "Window to Desktop ${num}" ["${hyper}+${num}" "Meta+Ctrl+Alt+${glyph}"])
    ])
    shifted));
in {
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

      # KRunner as the Alfred equivalent: centred, Alt+Space like Alfred's default
      krunner = {
        position = "center";
        activateWhenTypingOnDesktop = true;
        historyBehavior = "enableSuggestions";
        shortcuts.launch = ["Alt+Space" "Alt+F2"];
      };

      # Plugins not covered by plasma-manager options; IDs are the plugin file names
      configFile.krunnerrc.Plugins = {
        krunner_appstreamEnabled = false; # Discover packages, unused on NixOS
        krunner_katesessionsEnabled = false; # Kate isn't used
        krunner_konsoleprofilesEnabled = false; # Kitty is the terminal
      };

      # Keyboard shortcuts (using CapsLock = Meh = Ctrl+Alt+Shift)
      shortcuts = {
        kwin =
          workspaceShortcuts
          // {
            # Window focus navigation (vim-style H/J/K/L)
            "Switch Window Left" = "${meh}+H";
            "Switch Window Down" = "${meh}+J";
            "Switch Window Up" = "${meh}+K";
            "Switch Window Right" = "${meh}+L";

            # Snap windows to screen halves (closest stock KWin gets to `move`)
            "Window Quick Tile Left" = "${hyper}+H";
            "Window Quick Tile Bottom" = "${hyper}+J";
            "Window Quick Tile Top" = "${hyper}+K";
            "Window Quick Tile Right" = "${hyper}+L";

            # Fullscreen (Meh+F) and maximise (Hyper+F, like native fullscreen)
            "Window Fullscreen" = "${meh}+F";
            "Window Maximize" = "${hyper}+F";

            # Send window to the next monitor
            "Window to Next Screen" = "${hyper}+Tab";

            # Window close; keep Alt+F4 since keyd maps Cmd+Q to it
            "Window Close" = ["${meh}+Q" "Alt+F4"];
          };
      };
    };
  };
}
