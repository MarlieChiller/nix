{
  config,
  lib,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;

    settings = {
      # Monitor configuration
      monitor = [
        ",preferred,auto,1.5" # 150% scaling for all monitors
      ];

      # Input configuration
      input = {
        kb_layout = "gb";
        follow_mouse = 1;

        touchpad = {
          natural_scroll = false;
        };

        # Flat acceleration profile for pointer
        accel_profile = "flat";
        sensitivity = 0;
      };

      # General window and workspace behavior
      general = {
        gaps_in = 8;
        gaps_out = 8;
        border_size = 3;

        # Colors managed by Stylix

        layout = "dwindle";
        allow_tearing = false;
      };

      # Decorations (rounded corners, blur, shadows)
      decoration = {
        rounding = 8;

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
      };

      # Animations
      animations = {
        enabled = true;

        bezier = [
          "myBezier, 0.05, 0.9, 0.1, 1.05"
        ];

        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      # Dwindle layout settings
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      # Misc settings
      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };

      # XWayland
      xwayland = {
        force_zero_scaling = true;
      };

      # Environment variables
      env = [
        "XCURSOR_SIZE,24"
      ];

      # Key bindings - using Meh (Ctrl+Alt+Shift) to match Aerospace on macOS
      "$mod" = "CTRL ALT SHIFT"; # Meh modifier
      "$modMove" = "CTRL ALT SHIFT SUPER"; # Meh + Super for move operations

      bind = [
        # Application launcher (Super+Space like Alfred on macOS)
        "SUPER, Space, exec, ulauncher-toggle"

        # Terminal
        "$mod, Return, exec, kitty"

        # Close window (matching Cmd+W on macOS)
        "SUPER, W, killactive,"

        # Focus windows (hjkl like Aerospace)
        "$mod, h, movefocus, l"
        "$mod, j, movefocus, d"
        "$mod, k, movefocus, u"
        "$mod, l, movefocus, r"

        # Move windows (Meh+Super matching Aerospace)
        "$modMove, h, movewindow, l"
        "$modMove, j, movewindow, d"
        "$modMove, k, movewindow, u"
        "$modMove, l, movewindow, r"

        # Fullscreen (matching Aerospace)
        "$mod, f, fullscreen, 0"

        # Layout toggle (matching Aerospace slash/comma)
        "$mod, slash, togglesplit,"
        "$mod, comma, pseudo," # Pseudo-tiling

        # Enable/disable tiling (matching Aerospace esc)
        "$mod, Escape, togglefloating,"

        # Workspaces 1-9
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"

        # Named workspaces A-Z (matching Aerospace)
        "$mod, a, workspace, name:A"
        "$mod, b, workspace, name:B"
        "$mod, c, workspace, name:C"
        "$mod, d, workspace, name:D"
        "$mod, e, workspace, name:E"
        "$mod, g, workspace, name:G"
        "$mod, i, workspace, name:I"
        "$mod, n, workspace, name:N"
        "$mod, o, workspace, name:O"
        "$mod, p, workspace, name:P"
        "$mod, q, workspace, name:Q"
        "$mod, r, workspace, name:R"
        "$mod, s, workspace, name:S"
        "$mod, t, workspace, name:T"
        "$mod, u, workspace, name:U"
        "$mod, v, workspace, name:V"
        "$mod, w, workspace, name:W"
        "$mod, x, workspace, name:X"
        "$mod, y, workspace, name:Y"
        "$mod, z, workspace, name:Z"

        # Move to workspaces 1-9 (Meh+Super matching Aerospace)
        "$modMove, 1, movetoworkspace, 1"
        "$modMove, 2, movetoworkspace, 2"
        "$modMove, 3, movetoworkspace, 3"
        "$modMove, 4, movetoworkspace, 4"
        "$modMove, 5, movetoworkspace, 5"
        "$modMove, 6, movetoworkspace, 6"
        "$modMove, 7, movetoworkspace, 7"
        "$modMove, 8, movetoworkspace, 8"
        "$modMove, 9, movetoworkspace, 9"

        # Move to named workspaces A-Z (Meh+Super matching Aerospace)
        "$modMove, a, movetoworkspace, name:A"
        "$modMove, b, movetoworkspace, name:B"
        "$modMove, c, movetoworkspace, name:C"
        "$modMove, d, movetoworkspace, name:D"
        "$modMove, e, movetoworkspace, name:E"
        "$modMove, g, movetoworkspace, name:G"
        "$modMove, i, movetoworkspace, name:I"
        "$modMove, n, movetoworkspace, name:N"
        "$modMove, o, movetoworkspace, name:O"
        "$modMove, p, movetoworkspace, name:P"
        "$modMove, q, movetoworkspace, name:Q"
        "$modMove, r, movetoworkspace, name:R"
        "$modMove, s, movetoworkspace, name:S"
        "$modMove, t, movetoworkspace, name:T"
        "$modMove, u, movetoworkspace, name:U"
        "$modMove, v, movetoworkspace, name:V"
        "$modMove, w, movetoworkspace, name:W"
        "$modMove, x, movetoworkspace, name:X"
        "$modMove, y, movetoworkspace, name:Y"
        "$modMove, z, movetoworkspace, name:Z"

        # Workspace back and forth (matching Aerospace tab)
        "$mod, Tab, workspace, previous"

        # Reload config (Meh+Super+semicolon)
        "$modMove, semicolon, exec, hyprctl reload"

        # Screenshot utilities
        ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
        "SHIFT, Print, exec, grim - | wl-copy"
      ];

      # Resize bindings (matching Aerospace -/=)
      binde = [
        "$mod, minus, resizeactive, -50 0"
        "$mod, equal, resizeactive, 50 0"
      ];

      # Mouse bindings
      bindm = [
        # Move/resize windows with mouse (Alt + LMB/RMB)
        "ALT, mouse:272, movewindow"
        "ALT, mouse:273, resizewindow"
      ];

      # Window rules - Application-specific workspace assignments (matching Aerospace)
      windowrulev2 = [
        # Browser -> B
        "workspace name:B, class:^(firefox)$"
        "workspace name:B, class:^(Google-chrome)$"
        "workspace name:B, class:^(Chromium)$"

        # Terminal -> T
        "workspace name:T, class:^(kitty)$"

        # IDEs -> C
        "workspace name:C, class:^(jetbrains-.*)$"

        # Postman -> P
        "workspace name:P, class:^(Postman)$"

        # Communication -> 5
        "workspace 5, class:^(Slack)$"
        "workspace 5, class:^(Microsoft Teams)$"

        # Discord -> D
        "workspace name:D, class:^(discord)$"

        # Spotify -> S
        "workspace name:S, class:^(Spotify)$"

        # Obsidian -> O
        "workspace name:O, class:^(obsidian)$"

        # WhatsApp/Whimsical -> W
        "workspace name:W, class:^(whatsapp)$"
        "workspace name:W, class:^(Whimsical)$"

        # ChatGPT -> 9
        "workspace 9, class:^(ChatGPT)$"

        # Steam/Gaming -> G
        "workspace name:G, class:^(steam)$"
        "workspace name:G, class:^(Steam)$"

        # Steam window rules for better gaming experience
        "float, class:^(steam)$, title:^(Steam - News)$"
        "float, class:^(steam)$, title:^(Friends List)$"
        "float, class:^(steam)$, title:^(Settings)$"

        # Auto-fullscreen for games
        "fullscreen, class:^(steam_app_.*)$"

        # Tearing for games (performance)
        "immediate, class:^(steam_app_.*)$"
      ];

      # Startup applications
      exec-once = [
        "waybar"
        "ulauncher --hide-window"
        "swaync" # Notification center with system tray
        "1password --silent" # 1Password daemon
        "tailscale-systray" # Tailscale system tray icon
        "protonvpn-app" # ProtonVPN system tray
      ];
    };
  };

  # Install Hyprland-related packages
  home.packages = lib.optionals pkgs.stdenv.isLinux (with pkgs; [
    ulauncher # Application launcher (Alfred-like)
    waybar # Status bar
    wl-clipboard # Clipboard utilities
    grim # Screenshot tool
    slurp # Screen area selection
    swaylock # Screen locker
    swayidle # Idle management
    swaynotificationcenter # Notification center with history and tray icon
    hyprpicker # Color picker
    hyprpaper # Wallpaper daemon (alternative to swaybg)
    wlogout # Logout/power menu
    mangohud # Gaming performance overlay
    gamemode # Gaming optimizations
  ]);

  # Waybar configuration (updated for Hyprland)
  programs.waybar = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 40;
        spacing = 8;

        modules-left = ["hyprland/workspaces" "hyprland/submap"];
        modules-center = ["hyprland/window"];
        modules-right = ["network" "cpu" "memory" "clock" "tray" "custom/power"];

        "hyprland/workspaces" = {
          format = "{name}";
          on-click = "activate";
          sort-by-number = true;
          all-outputs = true;
          format-icons = {
            active = "";
            default = "";
          };
        };

        "hyprland/window" = {
          max-length = 50;
          separate-outputs = true;
        };

        "hyprland/submap" = {
          format = " {}";
          max-length = 8;
          tooltip = false;
        };

        clock = {
          format = "{:%H:%M   %d/%m/%Y}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        cpu = {
          format = "CPU {usage}%";
          tooltip = true;
          interval = 2;
        };

        memory = {
          format = "MEM {percentage}%";
          tooltip-format = "RAM: {used:0.1f}G / {total:0.1f}G\nSwap: {swapUsed:0.1f}G / {swapTotal:0.1f}G";
          interval = 2;
        };

        network = {
          format-wifi = "WiFi {essid}";
          format-ethernet = "ETH {ipaddr}";
          format-disconnected = "Disconnected";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}";
          tooltip-format-wifi = "{essid} ({signalStrength}%)\n {ipaddr}/{cidr}";
          tooltip-format-ethernet = "{ifname}\n {ipaddr}/{cidr}";
          on-click = "kitty -e nmtui";
        };

        tray = {
          icon-size = 18;
          spacing = 8;
        };

        "custom/power" = {
          format = "⏻";
          on-click = "${pkgs.wlogout}/bin/wlogout";
          tooltip = false;
        };
      };
    };

    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background: transparent;
      }

      #workspaces {
        margin: 4px 4px 4px 8px;
        padding: 0 4px;
        border-radius: 8px;
      }

      #workspaces button {
        padding: 4px 10px;
        margin: 2px 3px;
        border-radius: 6px;
        transition: all 0.3s ease;
      }

      #workspaces button.active {
        padding: 4px 12px;
      }

      #workspaces button:hover {
        box-shadow: inherit;
      }

      #submap {
        margin: 4px;
        padding: 4px 12px;
        border-radius: 8px;
      }

      #window {
        margin: 4px;
        padding: 4px 12px;
        border-radius: 8px;
        font-weight: bold;
      }

      #clock,
      #cpu,
      #memory,
      #network,
      #tray,
      #custom-power {
        margin: 4px 4px;
        padding: 4px 12px;
        border-radius: 8px;
      }

      #custom-power {
        margin-right: 8px;
        font-size: 16px;
        padding: 4px 10px;
      }

      #tray {
        padding: 4px 8px;
      }
    '';
  };

  # SwayNC notification center configuration
  services.swaync = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    settings = {
      positionX = "right";
      positionY = "top";
      timeout = 5;
      timeout-low = 3;
      timeout-critical = 0;
      notification-window-width = 400;
      keyboard-shortcuts = true;
      image-visibility = "when-available";
      transition-time = 200;
      hide-on-clear = false;
      hide-on-action = true;
      script-fail-notify = true;

      widgets = [
        "title"
        "dnd"
        "notifications"
      ];

      widget-config = {
        title = {
          text = "Notifications";
          clear-all-button = true;
          button-text = "Clear All";
        };
        dnd = {
          text = "Do Not Disturb";
        };
      };
    };
  };
}
