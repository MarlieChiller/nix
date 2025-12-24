{
  config,
  lib,
  pkgs,
  ...
}: {
  wayland.windowManager.sway = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    config = rec {
      # Meh key (Alt+Shift+Ctrl) - matches Aerospace
      modifier = "Mod1+Shift+Control";

      # Terminal
      terminal = "kitty";

      # Application launcher
      menu = "wofi --show drun";

      # Window borders and gaps (matching Aerospace 8px)
      gaps = {
        inner = 8;
        outer = 8;
      };

      window = {
        border = 3;
        titlebar = false;
      };

      # Focus follows mouse
      focus.followMouse = "yes";

      # Key bindings
      keybindings = let
        mod = modifier;
      in lib.mkOptionDefault {
        # Focus windows (hjkl like Aerospace)
        "${mod}+h" = "focus left";
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+l" = "focus right";

        # Move windows (Mod+Cmd in Aerospace = Mod+Mod4 in Sway)
        "${mod}+Mod4+h" = "move left";
        "${mod}+Mod4+j" = "move down";
        "${mod}+Mod4+k" = "move up";
        "${mod}+Mod4+l" = "move right";

        # Resize (matching Aerospace -/=)
        "${mod}+minus" = "resize shrink width 50px";
        "${mod}+equal" = "resize grow width 50px";

        # Fullscreen (matching Aerospace)
        "${mod}+f" = "fullscreen toggle";

        # Layout toggle (matching Aerospace slash/comma)
        "${mod}+slash" = "layout toggle split";
        "${mod}+comma" = "layout tabbed";

        # Enable/disable tiling (matching Aerospace esc)
        "${mod}+Escape" = "floating toggle";

        # Workspaces 1-9
        "${mod}+1" = "workspace number 1";
        "${mod}+2" = "workspace number 2";
        "${mod}+3" = "workspace number 3";
        "${mod}+4" = "workspace number 4";
        "${mod}+5" = "workspace number 5";
        "${mod}+6" = "workspace number 6";
        "${mod}+7" = "workspace number 7";
        "${mod}+8" = "workspace number 8";
        "${mod}+9" = "workspace number 9";

        # Named workspaces A-Z (matching Aerospace)
        "${mod}+a" = "workspace A";
        "${mod}+b" = "workspace B";
        "${mod}+c" = "workspace C";
        "${mod}+d" = "workspace D";
        "${mod}+e" = "workspace E";
        "${mod}+g" = "workspace G";
        "${mod}+i" = "workspace I";
        "${mod}+n" = "workspace N";
        "${mod}+o" = "workspace O";
        "${mod}+p" = "workspace P";
        "${mod}+q" = "workspace Q";
        "${mod}+r" = "workspace R";
        "${mod}+s" = "workspace S";
        "${mod}+t" = "workspace T";
        "${mod}+u" = "workspace U";
        "${mod}+v" = "workspace V";
        "${mod}+w" = "workspace W";
        "${mod}+x" = "workspace X";
        "${mod}+y" = "workspace Y";
        "${mod}+z" = "workspace Z";

        # Move to workspaces 1-9
        "${mod}+Mod4+1" = "move container to workspace number 1";
        "${mod}+Mod4+2" = "move container to workspace number 2";
        "${mod}+Mod4+3" = "move container to workspace number 3";
        "${mod}+Mod4+4" = "move container to workspace number 4";
        "${mod}+Mod4+5" = "move container to workspace number 5";
        "${mod}+Mod4+6" = "move container to workspace number 6";
        "${mod}+Mod4+7" = "move container to workspace number 7";
        "${mod}+Mod4+8" = "move container to workspace number 8";
        "${mod}+Mod4+9" = "move container to workspace number 9";

        # Move to named workspaces A-Z
        "${mod}+Mod4+a" = "move container to workspace A";
        "${mod}+Mod4+b" = "move container to workspace B";
        "${mod}+Mod4+c" = "move container to workspace C";
        "${mod}+Mod4+d" = "move container to workspace D";
        "${mod}+Mod4+e" = "move container to workspace E";
        "${mod}+Mod4+g" = "move container to workspace G";
        "${mod}+Mod4+i" = "move container to workspace I";
        "${mod}+Mod4+n" = "move container to workspace N";
        "${mod}+Mod4+o" = "move container to workspace O";
        "${mod}+Mod4+p" = "move container to workspace P";
        "${mod}+Mod4+q" = "move container to workspace Q";
        "${mod}+Mod4+r" = "move container to workspace R";
        "${mod}+Mod4+s" = "move container to workspace S";
        "${mod}+Mod4+t" = "move container to workspace T";
        "${mod}+Mod4+u" = "move container to workspace U";
        "${mod}+Mod4+v" = "move container to workspace V";
        "${mod}+Mod4+w" = "move container to workspace W";
        "${mod}+Mod4+x" = "move container to workspace X";
        "${mod}+Mod4+y" = "move container to workspace Y";
        "${mod}+Mod4+z" = "move container to workspace Z";

        # Workspace back and forth (matching Aerospace tab)
        "${mod}+Tab" = "workspace back_and_forth";

        # Reload config
        "${mod}+Mod4+semicolon" = "reload";
      };

      # Colors (Nord theme to match your Stylix)
      colors = {
        focused = {
          border = "#88c0d0";
          background = "#88c0d0";
          text = "#2e3440";
          indicator = "#88c0d0";
          childBorder = "#88c0d0";
        };
        focusedInactive = {
          border = "#4c566a";
          background = "#4c566a";
          text = "#d8dee9";
          indicator = "#4c566a";
          childBorder = "#4c566a";
        };
        unfocused = {
          border = "#3b4252";
          background = "#3b4252";
          text = "#d8dee9";
          indicator = "#3b4252";
          childBorder = "#3b4252";
        };
      };

      # Application-specific workspace assignments (matching Aerospace)
      assigns = {
        "B" = [{app_id = "firefox";} {class = "Google-chrome";} {class = "Chromium";}];
        "T" = [{app_id = "kitty";}];
        "C" = [{class = "jetbrains-.*";}];
        "P" = [{class = "Postman";}];
        "5" = [{class = "Slack";} {class = "Microsoft Teams";}];
        "D" = [{class = "discord";}];
        "S" = [{class = "Spotify";}];
        "O" = [{class = "obsidian";}];
        "W" = [{class = "whatsapp";} {class = "Whimsical";}];
        "9" = [{class = "ChatGPT";}];
        "G" = [{class = "^steam.*";} {class = "^Steam.*";}];
      };

      # Window rules for better gaming experience
      window.commands = [
        # Make Steam windows floating by default (except main window)
        {
          criteria = {class = "^steam$"; title = "^Steam - News";};
          command = "floating enable";
        }
        {
          criteria = {class = "^steam$"; title = "^Friends List";};
          command = "floating enable";
        }
        {
          criteria = {class = "^steam$"; title = "^Settings";};
          command = "floating enable";
        }
        # Auto-fullscreen for games
        {
          criteria = {class = "^steam_app_.*";};
          command = "fullscreen enable";
        }
      ];

      # Startup applications
      startup = [
        {command = "waybar";}
      ];
    };

    # Extra config for things not covered by home-manager options
    extraConfig = ''
      # Mouse follows focus when changing monitors
      mouse_warping container

      # Default orientation
      default_orientation auto
    '';
  };

  # Install Sway-related packages
  home.packages = lib.optionals pkgs.stdenv.isLinux (with pkgs; [
    wofi           # Application launcher (like dmenu/rofi)
    waybar         # Status bar
    wl-clipboard   # Clipboard utilities
    grim           # Screenshot tool
    slurp          # Screen area selection
    swaylock       # Screen locker
    swayidle       # Idle management
    mako           # Notification daemon
    mangohud       # Gaming performance overlay
    gamemode       # Gaming optimizations
  ]);

  # Waybar configuration
  programs.waybar = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;

        modules-left = ["sway/workspaces" "sway/mode"];
        modules-center = ["sway/window"];
        modules-right = ["network" "cpu" "memory" "clock"];

        "sway/workspaces" = {
          all-outputs = true;
          format = "{name}";
        };

        clock = {
          format = "{:%H:%M %d/%m/%Y}";
        };

        cpu = {
          format = "CPU: {usage}%";
        };

        memory = {
          format = "MEM: {percentage}%";
        };

        network = {
          format-wifi = "WiFi: {essid}";
          format-ethernet = "ETH: {ipaddr}";
          format-disconnected = "Disconnected";
        };
      };
    };
  };
}
