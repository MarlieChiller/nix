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
    casks = [
      "discord"
      "obsidian"
      "protonvpn"
      "signal"
      "whatsapp"
    ];
  };
  stylix = {
    enable = true;
    image = ../assets/wallpapers/mountain.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
  };
  users.users.marliechiller = {
    home = "/Users/marliechiller";
    shell = pkgs.fish;
  };

}
