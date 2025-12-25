{pkgs, ...}: let
  users = import ../../users.nix;
  userConfig = users.work;
in {
  imports = [
    ../common # system/common - shared across all systems
    ./common.nix # system/darwin/common.nix - darwin-specific shared
  ];

  environment.darwinConfig = "$HOME/Projects/nix/system/darwin/work.nix";

  # Disable nix-darwin's nix package management since we use Determinate Systems installer
  # which manages nix itself (auto-updates, etc.)
  nix.enable = false;

  # Work-specific homebrew packages
  homebrew = {
    brews = [
      "libpq"
      "msodbcsql18"
      "mssql-tools"
      "pipx"
      "postgresql"
      "unixodbc"
      "zlib"
    ];
    casks = [
      # zego
      "datagrip"
      "postman"
      "pycharm"
      "intellij-idea"
      "whimsical"
    ];
    taps = [
      "microsoft/mssql-release"
    ];
    # Cleanup must be in child configs (not common) to prevent double-application
    # which causes packages to be removed and reinstalled on every rebuild
    onActivation = {
      cleanup = "zap";
    };
  };

  # Work-specific stylix theming
  stylix = {
    image = ../../home-manager/assets/wallpapers/leaves.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
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
