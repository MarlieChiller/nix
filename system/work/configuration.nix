{pkgs, ...}: {
  imports = [../common/configuration.nix];
  # Use a custom configuration.nix location.
  environment.darwinConfig = "$HOME/Projects/nix/system/work/configuration.nix";
  nix.enable = false;

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
      # zego
      "postman"
      "datagrip"
      "docker"
      "visual-studio-code"
    ];
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
  system.primaryUser = "charlie.miller";

  users.users."charlie.miller" = {
    home = "/Users/charlie.miller";
    shell = pkgs.fish;
  };
}
