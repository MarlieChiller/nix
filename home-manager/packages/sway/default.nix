{
  config,
  lib,
  pkgs,
  ...
}: {
  wayland.windowManager.sway = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    config = rec {
      # Disable default bar (we use waybar instead)
      bars = [];

      # Modifier is set to Mod4 but not used (we override all keybindings below)
      # This is just to satisfy the config option
      modifier = "Mod4";

      # Floating modifier must be a simple key (use Alt for dragging windows)
      floating.modifier = "Mod1";

      # Terminal
      terminal = "kitty";

      # Application launcher (ulauncher for Alfred-like experience)
      menu = "ulauncher-toggle";

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

      # Key bindings - using Meh (Ctrl+Alt+Shift) to match Aerospace on macOS
      # Configure your Moonlander to send Ctrl+Alt+Shift on a layer key
      keybindings = let
        # Meh modifier (matching Aerospace: alt-shift-ctrl)
        mod = "Ctrl+Mod1+Shift";
        # For move operations, add Mod4 (Super/Cmd)
        modMove = "Ctrl+Mod1+Shift+Mod4";
      in
        lib.mkOptionDefault {
          # Ulauncher (Super+Space like Alfred on macOS)
          "Mod4+space" = "exec ulauncher-toggle";

          # Focus windows (hjkl like Aerospace)
          "${mod}+h" = "focus left";
          "${mod}+j" = "focus down";
          "${mod}+k" = "focus up";
          "${mod}+l" = "focus right";

          # Move windows (Meh+Cmd matching Aerospace)
          "${modMove}+h" = "move left";
          "${modMove}+j" = "move down";
          "${modMove}+k" = "move up";
          "${modMove}+l" = "move right";

          # Resize (matching Aerospace -/=)
          "${mod}+minus" = "resize shrink width 50px";
          "${mod}+equal" = "resize grow width 50px";

          # Fullscreen (matching Aerospace)
          "${mod}+f" = "fullscreen toggle";

          # Close window (matching Cmd+W on macOS)
          "Mod4+w" = "kill";

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

          # Move to workspaces 1-9 (Meh+Cmd matching Aerospace)
          "${modMove}+1" = "move container to workspace number 1";
          "${modMove}+2" = "move container to workspace number 2";
          "${modMove}+3" = "move container to workspace number 3";
          "${modMove}+4" = "move container to workspace number 4";
          "${modMove}+5" = "move container to workspace number 5";
          "${modMove}+6" = "move container to workspace number 6";
          "${modMove}+7" = "move container to workspace number 7";
          "${modMove}+8" = "move container to workspace number 8";
          "${modMove}+9" = "move container to workspace number 9";

          # Move to named workspaces A-Z (Meh+Cmd matching Aerospace)
          "${modMove}+a" = "move container to workspace A";
          "${modMove}+b" = "move container to workspace B";
          "${modMove}+c" = "move container to workspace C";
          "${modMove}+d" = "move container to workspace D";
          "${modMove}+e" = "move container to workspace E";
          "${modMove}+g" = "move container to workspace G";
          "${modMove}+i" = "move container to workspace I";
          "${modMove}+n" = "move container to workspace N";
          "${modMove}+o" = "move container to workspace O";
          "${modMove}+p" = "move container to workspace P";
          "${modMove}+q" = "move container to workspace Q";
          "${modMove}+r" = "move container to workspace R";
          "${modMove}+s" = "move container to workspace S";
          "${modMove}+t" = "move container to workspace T";
          "${modMove}+u" = "move container to workspace U";
          "${modMove}+v" = "move container to workspace V";
          "${modMove}+w" = "move container to workspace W";
          "${modMove}+x" = "move container to workspace X";
          "${modMove}+y" = "move container to workspace Y";
          "${modMove}+z" = "move container to workspace Z";

          # Workspace back and forth (matching Aerospace tab)
          "${mod}+Tab" = "workspace back_and_forth";

          # Reload config (Meh+Cmd+semicolon enters service mode in Aerospace)
          "${modMove}+semicolon" = "reload";
        };

      # Colors managed by Stylix (Nord theme)
      # Removed manual color config to avoid conflicts with Stylix

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
          criteria = {
            class = "^steam$";
            title = "^Steam - News";
          };
          command = "floating enable";
        }
        {
          criteria = {
            class = "^steam$";
            title = "^Friends List";
          };
          command = "floating enable";
        }
        {
          criteria = {
            class = "^steam$";
            title = "^Settings";
          };
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
        {command = "ulauncher --hide-window";}  # Start ulauncher daemon in background
      ];
    };

    # Extra config for things not covered by home-manager options
    extraConfig = ''
      # Mouse follows focus when changing monitors
      mouse_warping container

      # Default orientation
      default_orientation auto

      # Mouse/pointer configuration
      input type:pointer {
        accel_profile flat
        pointer_accel 0
      }

      # Display scaling (150%)
      output * scale 1.5

      # XWayland configuration for Steam
      xwayland force
    '';
  };

  # Install Sway-related packages
  home.packages = lib.optionals pkgs.stdenv.isLinux (with pkgs; [
    ulauncher # Application launcher (Alfred-like)
    waybar # Status bar
    wl-clipboard # Clipboard utilities
    grim # Screenshot tool
    slurp # Screen area selection
    swaylock # Screen locker
    swayidle # Idle management
    mako # Notification daemon
    mangohud # Gaming performance overlay
    gamemode # Gaming optimizations
  ]);

  # Waybar configuration
  programs.waybar = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 36;

        modules-left = ["sway/workspaces" "sway/mode"];
        modules-center = ["sway/window"];
        modules-right = ["custom/protonvpn" "custom/tailscale" "network" "cpu" "memory" "clock"];

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

        "custom/tailscale" = {
          exec = "tailscale status --json | ${pkgs.jq}/bin/jq -r 'if .BackendState == \"Running\" then \"TS: \" + .Self.TailscaleIPs[0] else \"TS: Off\" end'";
          interval = 10;
          format = "{}";
          tooltip = true;
          exec-tooltip = "tailscale status | head -5";
        };

        "custom/protonvpn" = {
          exec = ''
            if ${pkgs.procps}/bin/pgrep -x "protonvpn" > /dev/null || ${pkgs.networkmanager}/bin/nmcli connection show --active | ${pkgs.gnugrep}/bin/grep -i proton > /dev/null; then
              echo "VPN: On"
            else
              echo "VPN: Off"
            fi
          '';
          interval = 5;
          format = "{}";
          on-click = "${pkgs.protonvpn-gui}/bin/protonvpn-app";
          tooltip = true;
          exec-tooltip = "${pkgs.networkmanager}/bin/nmcli connection show --active | ${pkgs.gnugrep}/bin/grep -i proton || echo 'ProtonVPN: Disconnected'";
        };
      };
    };
  };
}
