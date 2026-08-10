{pkgs, ...}: {
  # Darwin-specific shared configuration (imported by both home and work)

  # Darwin-specific packages
  environment.systemPackages = [
    # pkgs.wireshark # Temporarily disabled - build fails due to Qt 6.10.0 requiring macOS 12.0+ deployment target
    pkgs.colima
    pkgs.docker
    pkgs.docker-compose
    pkgs.direnv
  ];
  # Use homebrew to install casks and Mac App Store apps
  # https://daiderd.com/nix-darwin/manual/index.html
  homebrew = {
    enable = true;
    brews = [
      "bun"
      "gettext"
      "coreutils" # provides grealpath needed by yazi.nvim
    ];
    # Homebrew 6 refuses to load formulae/casks from non-official taps that
    # aren't trusted, which aborts nix-darwin activation. Per-formula `trusted`
    # only applies to fully-qualified names, so it can't cover plain names or
    # transitive dependencies — trust has to be declared at tap level.
    taps = [
      {
        name = "nikitabobko/tap"; # aerospace - an i3-like tiling window manager for macOS
        trusted = true;
      }
      {
        name = "FelixKratz/formulae"; # janky borders - highlight active window borders
        trusted = true;
      }
      {
        name = "oven-sh/bun"; # bun - fast all-in-one JavaScript runtime
        trusted = true;
      }
    ];
    casks = [
      "1password"
      "1password-cli"
      "aerospace"
      "alfred"
      "chatgpt"
      "firefox"
      "fork"
      "font-hack-nerd-font"
      "font-jetbrains-mono-nerd-font"
      "ghostty"
      "google-chrome"
      "jordanbaird-ice"
      "karabiner-elements"
      "obsidian"
      "sf-symbols"
      "spotify"
      "stats"
      "tailscale-app"
    ];
    onActivation = {
      autoUpdate = true;
    };
  };
  # Enable stylix for theming
  stylix = {
    enable = true;
  };

  # Touch ID for sudo (falls back to password)
  security.pam.services.sudo_local.touchIdAuth = true;

  # Enable zsh (macOS default shell)
  programs.zsh.enable = true;

  # This is the initial nix-darwin stateVersion from first install. Do not change.
  system.stateVersion = 5;
  system.keyboard = {
    enableKeyMapping = true;
  };

  system.defaults = {
    # minimal dock
    dock = {
      autohide = true;
      orientation = "bottom";
    };
    NSGlobalDomain."com.apple.swipescrolldirection" = false;
    # Finder that tells me what I want to know and lets me work
    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      _FXShowPosixPathInTitle = true; # show full path in finder title
      FXEnableExtensionChangeWarning = false;
      FXPreferredViewStyle = "Nlsv";
      ShowStatusBar = true;
      ShowPathbar = true;
      QuitMenuItem = true;
    };
    controlcenter = {
      BatteryShowPercentage = true;
      Bluetooth = true;
    };
  };
}
