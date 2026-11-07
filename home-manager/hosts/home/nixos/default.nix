{
  userConfig,
  pkgs,
  ...
}: let
  mangohudLogs = "/mnt/storage/mangohud-logs";

  # Local models served by services.ollama (system/nixos/configuration.nix).
  # contextWindowSize matches OLLAMA_CONTEXT_LENGTH there.
  ollamaModel = id: name: {
    inherit id name;
    envKey = "OLLAMA_API_KEY";
    baseUrl = "http://127.0.0.1:11434/v1";
    generationConfig = {
      timeout = 600000; # prompt processing is slow when layers spill to CPU
      contextWindowSize = 32768;
    };
  };
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

      # Terminal coding agent, pointed at local Ollama below
      qwen-code
    ];

    # Overrides privacy.usageStatisticsEnabled; defaults to on and reports to Alibaba Cloud
    sessionVariables.QWEN_USAGE_STATISTICS_ENABLED = "0";

    # Local-only: auth is pinned to the OpenAI-compatible provider so Qwen OAuth
    # (Alibaba's cloud) can't be picked by accident
    file.".qwen/settings.json".text = builtins.toJSON {
      env.OLLAMA_API_KEY = "ollama"; # Ollama ignores it, but the client requires one
      security.auth = {
        selectedType = "openai";
        enforcedType = "openai";
      };
      model.name = "qwen3-coder:30b";
      modelProviders.openai = [
        (ollamaModel "qwen3-coder:30b" "Qwen3 Coder 30B (local)")
        (ollamaModel "qwen3.8:27b" "Qwen3.8 27B (local)")
      ];
      privacy.usageStatisticsEnabled = false;
      telemetry.enabled = false;
      general.enableAutoUpdate = false; # Nix manages the version
    };
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
