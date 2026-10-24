{
  userConfig,
  pkgs,
  ...
}: let
  mangohudLogs = "/mnt/storage/mangohud-logs";
in {
  # Packages and userConfig passed from flake level

  home = {
    username = userConfig.username;
    homeDirectory = "/home/${userConfig.username}";
    stateVersion = "24.11"; # Please read the comment before changing.

    packages = with pkgs; [
      # Photo editing
      darktable
      krita

      # wl-copy/wl-paste: fish's Ctrl+V/Ctrl+X and Neovim's clipboard need them on Wayland
      wl-clipboard

      # GUI for tweaking MangoHud with a live preview
      goverlay
    ];
  };

  # In-game FPS/frametime overlay. Per game, set Steam launch options to `mangohud %command%`,
  # or `gamescope --mangoapp -- %command%` under gamescope
  programs.mangohud = {
    enable = true;
    settings = {
      fps = true;
      frametime = true;
      frame_timing = true; # frametime graph, shows stutter that average FPS hides
      cpu_stats = true;
      cpu_temp = true;
      gpu_stats = true;
      gpu_temp = true;
      vram = true;
      ram = true;
      position = "top-left";
      toggle_hud = "Shift_R+F12";
      toggle_logging = "Shift_L+F2"; # CSV with avg FPS and 1%/0.1% lows
      output_folder = mangohudLogs;
    };
  };

  systemd.user.tmpfiles.rules = ["d ${mangohudLogs} 0755 - - -"];
}
