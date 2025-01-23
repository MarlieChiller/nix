{pkgs, ...}: {
  imports = [../common/configuration.nix];
  # Use a custom configuration.nix location.
  environment.darwinConfig = "$HOME/Projects/nix/system/work/configuration.nix";

  # Use homebrew to install casks and Mac App Store apps
  # https://daiderd.com/nix-darwin/manual/index.html
  homebrew = {
    brews = [
      "coreutils"
      "zlib"
      "libpq"
      "postgresql"
      "docker-compose"
    ];
    casks = [
      # ocula
      "postman"
      "dbeaver-community"
      "docker"
      "visual-studio-code"
    ];
  };

  stylix = {
    image = ../assets/wallpapers/leaves.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
  };

  users.users.charliemiller = {
    home = "/Users/charliemiller";
    shell = pkgs.fish;
  };
}
