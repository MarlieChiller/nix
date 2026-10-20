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

  # With Shift held, Qt can report a symbol key as its shifted glyph (1 -> !,
  # / -> ?), so bind both spellings to be safe. Shifted glyphs assume the US
  # layout set in system/nixos/configuration.nix.
  shifted = {
    "1" = "!";
    "2" = "@";
    "3" = "#";
    "4" = "$";
    "5" = "%";
    "6" = "^";
    "7" = "&";
    "8" = "*";
    "9" = "(";
    "/" = "?";
    "," = "<";
    "-" = "_";
    "=" = "+";
  };
  bind = mods: key:
    if shifted ? ${key}
    then ["${mods}+${key}" "${lib.removeSuffix "+Shift" mods}+${shifted.${key}}"]
    else "${mods}+${key}";

  # Aerospace workspaces 1-9 plus the lettered ones its app rules use.
  # KWin desktops are numbered, so letters map onto desktops 10+.
  workspaces = map toString (lib.range 1 9) ++ ["B" "C" "D" "O" "P" "S" "T" "W"];
  workspaceShortcuts = lib.listToAttrs (lib.concatLists (lib.imap1 (n: ws: [
      (lib.nameValuePair "Switch to Desktop ${toString n}" (bind meh ws))
      (lib.nameValuePair "Window to Desktop ${toString n}" (bind hyper ws))
    ])
    workspaces));
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

        virtualDesktops.names = workspaces;

        # Polonium: i3-style tiling, the closest KWin analogue to Aerospace.
        # Most settings live in configFile below: plasma-manager's polonium.settings
        # still write pre-1.0 key names that Polonium 1.2 ignores.
        scripts.polonium = {
          enable = true;
          # One of the few settings whose key still matches; writes Borders = 2
          # (border on the active window only)
          settings.borderVisibility = "borderSelected";
        };
      };

      configFile.kwinrc."Script-polonium" = {
        # Never tile games or launchers. Polonium builds `^a|b|c$` from this
        # list without grouping, so middle entries match anywhere in the class
        # (e.g. "steam" also covers steam_app_<id> Proton windows).
        IgnoreWindowClasses = lib.concatStringsSep ", " [
          # Polonium defaults
          "krunner"
          "yakuake"
          "kded"
          "polkit"
          "plasmashell"
          "xwaylandvideobridge"
          # Gaming
          "steam"
          "gamescope"
          "[Ll]utris"
          "[Ww]ow[Uu]p"
          ".*\\.exe" # Wine/Proton windows report the Windows executable name
        ];
      };

      # Keyboard shortcuts (using CapsLock = Meh = Ctrl+Alt+Shift)
      shortcuts = {
        kwin =
          workspaceShortcuts
          // {
            # Window focus navigation (vim-style H/J/K/L)
            "Switch Window Left" = bind meh "H";
            "Switch Window Down" = bind meh "J";
            "Switch Window Up" = bind meh "K";
            "Switch Window Right" = bind meh "L";

            # Move windows within the tiling tree (Aerospace `move`)
            "PoloniumPlaceLeft" = bind hyper "H";
            "PoloniumPlaceBelow" = bind hyper "J";
            "PoloniumPlaceAbove" = bind hyper "K";
            "PoloniumPlaceRight" = bind hyper "L";

            # Fullscreen (Meh+F) and maximise (Hyper+F, like native fullscreen)
            "Window Fullscreen" = bind meh "F";
            "Window Maximize" = bind hyper "F";

            # Layouts: rotate split (`layout tiles`) and monocle (`layout accordion`)
            "PoloniumRotateLayout" = bind meh "/";
            "PoloniumSwitchMonocle" = bind meh ",";

            # Toggle floating for the active window
            "PoloniumToggleActiveTiling" = bind meh "Esc";

            # Resize (Aerospace `resize smart -50/+50`)
            "PoloniumResizeLeft" = bind meh "-";
            "PoloniumResizeRight" = bind meh "=";

            # Send window to the next monitor
            "Window to Next Screen" = bind hyper "Tab";

            # Window close
            "Window Close" = bind meh "Q";
          };
      };
    };
  };
}
