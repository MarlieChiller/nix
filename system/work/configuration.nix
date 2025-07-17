{pkgs, ...}: {
  imports = [../common/configuration.nix];
  # Use a custom configuration.nix location.
  environment.darwinConfig = "$HOME/Projects/nix/system/work/configuration.nix";

  # Use homebrew to install casks and Mac App Store apps
  # https://daiderd.com/nix-darwin/manual/index.html
  homebrew = {
    brews = [
      "coreutils"
      "docker-compose"
      "libpq"
      "pipx"
      "postgresql"
      "zlib"
    ];
    casks = [
      # ocula
      "postman"
      "datagrip"
      "dbeaver-community"
      "docker"
      "visual-studio-code"
    ];
  };

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
  system.primaryUser = "charliemiller";

  users.users.charliemiller = {
    home = "/Users/charliemiller";
    shell = pkgs.fish;
  };
}
