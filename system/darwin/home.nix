{
  config,
  pkgs,
  ...
}: let
  users = import ../../users.nix;
  userConfig = users.home;
in {
  imports = [
    ../common # system/common - shared across all systems
    ./common.nix # system/darwin/common.nix - darwin-specific shared
  ];

  environment.darwinConfig = "$HOME/Projects/nix/system/darwin/home.nix";

  # Home-specific homebrew packages
  homebrew = {
    # mac store apps
    masApps = {
      nextdns = 1464122853;
    };
    brews = [
      "postgresql@17"
    ];
    casks = [
      "discord"
      "protonvpn"
      "pycharm-ce"
      "qbittorrent"
      "rawtherapee"
      "signal"
      "steam"
      "whatsapp"
    ];
    # Cleanup must be in child configs (not common) to prevent double-application
    # which causes packages to be removed and reinstalled on every rebuild
    onActivation = {
      cleanup = "zap";
    };
  };
  # Home-specific stylix theming
  stylix = {
    image = ../../home-manager/assets/wallpapers/mountain.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sizes = {
        terminal = 14;
      };
    };
  };
  system.primaryUser = userConfig.username;
  users.users.${userConfig.username} = {
    home = "/Users/${userConfig.username}";
    shell = pkgs.fish;
  };
}
