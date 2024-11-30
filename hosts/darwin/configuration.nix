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
  ];

  # Use a custom configuration.nix location.
  environment.darwinConfig = "$HOME/Projects/nix/hosts/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
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
      "coreutils"
      "zlib"
      "libpq"
      "postgresql"
    ];
    taps = [
      "nikitabobko/tap" # aerospace - an i3-like tiling window manager for macOS
      "FelixKratz/formulae" # janky borders - highlight active window borders
      "homebrew/services"
    ];
    casks = [
      "1password"
      "aerospace"
      "chatgpt"
      "firefox"
      "font-hack-nerd-font"
      "gimp"
      "gitkraken"
      "karabiner-elements"
      "obsidian"
      "pycharm-ce"
      "sf-symbols"
      "spotify"
      "whatsapp"
      "zed"

      # ocula
      "postman"
      "dbeaver-community"
      "docker"
      "postico"
      "visual-studio-code"
    ];
    onActivation = {
      upgrade = true;
      cleanup = "zap";
    };
  };

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix

  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  programs.fish.enable = true; # default shell on catalina

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
  system.keyboard = {
    enableKeyMapping = true;
  };

  users.users.charliemiller = {
    home = "/Users/charliemiller";
    shell = pkgs.fish;
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
      FXEnableExtensionChangeWarning = false;
      ShowStatusBar = true;
      ShowPathbar = true;
      QuitMenuItem = true;
    };
  };
}
