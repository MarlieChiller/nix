{
  config,
  pkgs,
  ...
}: let
  users = import ../../users.nix;
  userConfig = users.home;
in {
  imports = [../common/configuration.nix];
  # Use a custom configuration.nix location.
  environment.darwinConfig = "$HOME/Projects/nix/system/home/configuration.nix";

  # Use homebrew to install casks and Mac App Store apps
  # https://daiderd.com/nix-darwin/manual/index.html
  homebrew = {
    enable = true;
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
  };
  stylix = {
    enable = true;
    image = ../../home-manager/assets/wallpapers/mountain.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
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
