{pkgs, ...}: let
  users = import ../../users.nix;
  userConfig = users.work;
in {
  imports = [../common/configuration.nix];
  # Use a custom configuration.nix location.
  environment.darwinConfig = "$HOME/Projects/nix/system/work/configuration.nix";
  nix.enable = false;

  # Use homebrew to install casks and Mac App Store apps
  # https://daiderd.com/nix-darwin/manual/index.html
  homebrew = {
    brews = [
      "coreutils"
      "libpq"
      "msodbcsql17"
      "msodbcsql18"
      "mssql-tools"
      "pipx"
      "postgresql"
      "unixodbc"
      "zlib"
    ];
    casks = [
      # zego
      "pycharm"
      "postman"
      "datagrip"
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

  stylix = {
    image = ../../home-manager/assets/wallpapers/leaves.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.hack;
        name = "Hack Nerd Font Mono";
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
