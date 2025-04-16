{
  config,
  pkgs,
  ...
}: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    pkgs.vim
    pkgs.fish
    pkgs.wireshark
  ];

  # Auto upgrade nix package and the daemon service.
  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = ["nix-command" "flakes"];
    };
  };
  # Use homebrew to install casks and Mac App Store apps
  # https://daiderd.com/nix-darwin/manual/index.html
  homebrew = {
    enable = true;
    brews = [
      "node"
      "gettext"
    ];
    taps = [
      "nikitabobko/tap" # aerospace - an i3-like tiling window manager for macOS
      "FelixKratz/formulae" # janky borders - highlight active window borders
      "homebrew/services"
    ];
    casks = [
      "1password"
      "1password-cli"
      "aerospace"
      "alfred"
      "chatgpt"
      "cursor"
      "firefox"
      "font-hack-nerd-font"
      "ghostty"
      "google-chrome"
      "karabiner-elements"
      "pycharm-ce"
      "sf-symbols"
      "spotify"
      "stats"
      "zed"
    ];
    onActivation = {
      upgrade = true;
      cleanup = "zap";
    };
  };
  stylix = {
    enable = true;
  };
  # Use a custom configuration.nix location.
  # $ work-rebuild switch -I work-config=$HOME/.config/nixpkgs/work/configuration.nix

  # Auto upgrade nix package and the daemon service.
  # nix.package = pkgs.nix;

  # Create /etc/zshrc that loads the nix-work environment.
  programs.zsh.enable = true; # default shell on catalina
  programs.fish.enable = true; # default shell on catalina

  # Used for backwards compatibility, please read the changelog before changing.
  # $ work-rebuild changelog
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
      _FXShowPosixPathInTitle = true;  # show full path in finder title
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
