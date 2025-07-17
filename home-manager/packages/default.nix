# common configuration across all system
{pkgs, inputs, ...}: {
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
    ./zellij
    inputs.mac-app-util.homeManagerModules.default
  ];

  news.display = "show";

  home.packages = with pkgs; [
    # cli
    btop
    cargo
    curl
    erdtree
    eza
    fd
    fish
    fzf
    gcc
    glow
    grc
    lazygit
    neofetch
    ripgrep
    ruff
    tre-command
    uv
    yazi
    zellij

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
  programs.home-manager.enable = true;
}
