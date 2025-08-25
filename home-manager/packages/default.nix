# common configuration across all system
{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./aerospace
    ./bat
    ./fish
    ./git
    ./kitty
    ./helix
    ./nixvim
    ./starship
    ./ssh
    ./wezterm
    ./yazi
    inputs.mac-app-util.homeManagerModules.default
  ];

  news.display = "show";

  home.packages = with pkgs; [
    # cli
    btop
    cargo
    claude-code
    curl
    erdtree
    eza
    fd
    fish
    fzf
    gcc
    glow
    go
    gh
    grc
    just
    lazygit
    ripgrep
    ruff
    tre-command
    uv
    yazi

    # darwin
    jankyborders

    # nix
    alejandra
    cachix
    nil
    nix-info
    nixci
    nix-health
  ];

  programs.fzf.enable = true;
  programs.fish.enable = true;

  programs.atuin = {
    enable = true;
    settings = {
      auto_sync = true;
      sync_frequency = "5m";
      sync_address = "https://api.atuin.sh";
      search_mode = "fuzzy";
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager = {
    enable = true;
    # backupFileExtension = true;
  };
}
