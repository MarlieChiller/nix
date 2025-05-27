{
  config,
  pkgs,
  ...
}: {
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
      "qbittorrent"
      "rawtherapee"
      "signal"
      "steam"
      "whatsapp"
    ];
  };
  stylix = {
    enable = true;
    image = ../assets/wallpapers/mountain.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
  };
  system.primaryUser = "marliechiller";
  users.users.marliechiller = {
    home = "/Users/marliechiller";
    shell = pkgs.fish;
  };

}
