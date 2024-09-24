#https://github.com/Aylur/dotfiles/blob/main/home-manager/hyprland.nix
{ inputs
, pkgs
, config
, outputs
, ...
}:
{
  home.packages = with pkgs; [
    rose-pine-cursor
    nwg-displays
    nwg-look
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;
    plugins = [
      # inputs.hyprland-hyprspace.packages.${pkgs.system}.default
      # plugins.hyprexpo
      # plugins.hyprbars
      # plugins.borderspp
    ];

    settings = {
      "$terminal" = "kitty";
      "$mod" = "SUPER";
      "$fileManager" = "dolphin";
      "$menu" = "rofi --show drun";

      exec-once = [
        "swww"
        "ags -b hypr"
        "nm-applet --indicator & disown"
        "hyprctl setcursor rose-pine-hyprcursor 24"

        # https://github.com/hyprwm/Hyprland/issues/6320
        "gsettings set org.gnome.desktop.interface cursor-theme rose-pine-hyprcursor"
        "gsettings set org.gnome.desktop.interface cursor-size 24"
      ];

      # monitor = [ (builtins.readFile ~/.config/hypr/workspaces.conf) ];
      monitor = [
        "eDP-1,2880x1800@120.0,2560x0,1.5"
        "DP-1,0x0@60.0,-1x-1,1.0"
        "DP-1,disable"
        "HDMI-A-1,3840x2160@60.0,0x0,1.5"
      ];

      general = {
        layout = "dwindle";
        resize_on_border = true;
      };

      env = [ 
        "HYPRCURSOR_THEME,rose-pine-hyprcursor"
        "HYPRCURSOR_SIZE,24"
        "XCURSOR_THEME,rose-pine-cursor"
        "XCURSOR_SIZE,24"
        "NIXOS_OZONE_WL,1"
        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,wayland"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      ];
      misc = {
        disable_splash_rendering = true;
        force_default_wallpaper = 1;
      };

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = false;
          disable_while_typing = true;
          drag_lock = true;
        };
        sensitivity = -0.1;
        float_switch_override_focus = 2;
        accel_profile = "flat";
      };

      binds = {
        allow_workspace_cycles = true;
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
        # no_gaps_when_only = "yes";
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_use_r = true;
      };

      decoration = {
        rounding = 5;
        drop_shadow = "yes";
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";

        dim_inactive = false;

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          new_optimizations = "on";
          noise = 0.01;
          contrast = 0.9;
          brightness = 0.8;
          popups = true;
        };
      };

      animations = {
        enabled = "yes";
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };
      windowrule =
        let
          f = regex: "float, ^(${regex})$";
        in
        [
          (f "org.gnome.Calculator")
          (f "org.gnome.Nautilus")
          (f "pavucontrol")
          (f "nm-connection-editor")
          (f "org.gnome.Settings")
          (f "org.gnome.design.Palette")
          (f "Color Picker")
          (f "xdg-desktop-portal")
          (f "xdg-desktop-portal-gnome")
          (f "com.github.Aylur.ags")
          "workspace 7, title:Spotify"
          "workspace 1, title:Firefox"
          "workspace 2, title:kitty"
        ];

      # https://github.com/Aylur/dotfiles/blob/18b83b2d2c6ef2b9045edefe49a66959f93b358a/home-manager/hyprland.nix
      bind =
        let
          e = "exec, ags -b hypr";
        in
        [
          # General
          "$mod, w, killactive"
          "$mod SHIFT, e, exit"
          "$mod SHIFT, l, exec, ${pkgs.hyprlock}/bin/hyprlock"

          # Screen focus
          "$mod, v, togglefloating"
          "$mod, u, focusurgentorlast"
          "$mod, tab, focuscurrentorlast"
          "$mod, f, fullscreen"
          "$mod, p, togglesplit"

          # Screen resize
          "$mod CTRL, h, resizeactive, -20 0"
          "$mod CTRL, l, resizeactive, 20 0"
          "$mod CTRL, k, resizeactive, 0 -20"
          "$mod CTRL, j, resizeactive, 0 20"

          # Workspaces
          "$mod, 1, workspace, 1"
          "$mod, 2, workspace, 2"
          "$mod, 3, workspace, 3"
          "$mod, 4, workspace, 4"
          "$mod, 5, workspace, 5"
          "$mod, 6, workspace, 6"
          "$mod, 7, workspace, 7"
          "$mod, 8, workspace, 8"
          "$mod, 9, workspace, 9"
          "$mod, 0, workspace, 10"

          # Move to workspaces
          "$mod SHIFT, 1, movetoworkspace,1"
          "$mod SHIFT, 2, movetoworkspace,2"
          "$mod SHIFT, 3, movetoworkspace,3"
          "$mod SHIFT, 4, movetoworkspace,4"
          "$mod SHIFT, 5, movetoworkspace,5"
          "$mod SHIFT, 6, movetoworkspace,6"
          "$mod SHIFT, 7, movetoworkspace,7"
          "$mod SHIFT, 8, movetoworkspace,8"
          "$mod SHIFT, 9, movetoworkspace,9"
          "$mod SHIFT, 0, movetoworkspace,10"

          # Navigation
          "$mod, h, movefocus, l"
          "$mod, l, movefocus, r"
          "$mod, k, movefocus, u"
          "$mod, j, movefocus, d"

          # Applications
          "$mod SHIFT, R,  ${e} quit; ags -b hypr"
          "$mod, t, exec, $terminal"
          "$mod, space, ${e} -t launcher"
          "$mod, b, exec, ${pkgs.firefox}/bin/firefox"
          "$mod ALT, e, exec, $terminal --hold -e ${pkgs.yazi}/bin/yazi"
          "$mod ALT, o, exec, ${pkgs.obsidian}/bin/obsidian"
        ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

    };
  };
    # services.greetd = {
    #   enable = true;
    #   settings.default_session.command = pkgs.writeShellScript "greeter" ''
    #     export XKB_DEFAULT_LAYOUT=${config.services.xserver.xkb.layout}
    #     export XCURSOR_THEME=Qogir
    #     ${outputs.packages}/bin/greeter
    #   '';
    # };
    #
    # systemd.tmpfiles.rules = [
    #   "d '/var/cache/greeter' - greeter greeter - -"
    # ];
    #
    # system.activationScripts.wallpaper = let
    #   wp = pkgs.writeShellScript "wp" ''
    #     CACHE="/var/cache/greeter"
    #     OPTS="$CACHE/options.json"
    #     HOME="/home/$(find /home -maxdepth 1 -printf '%f\n' | tail -n 1)"
    #
    #     mkdir -p "$CACHE"
    #     chown greeter:greeter $CACHE
    #
    #     if [[ -f "$HOME/.cache/ags/options.json" ]]; then
    #       cp $HOME/.cache/ags/options.json $OPTS
    #       chown greeter:greeter $OPTS
    #     fi
    #
    #     if [[ -f "$HOME/.config/background" ]]; then
    #       cp "$HOME/.config/background" $CACHE/background
    #       chown greeter:greeter "$CACHE/background"
    #     fi
    #   '';
    # in
    #   builtins.readFile wp;
    #
}
