# common configuration across all system
{pkgs, ...}: {
  imports = [
    ./aerospace
    ./bat
    ./fish
    ./git
    ./kitty
    ./helix
    ./starship
    ./ssh
    ./wezterm
    ./yazi
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
    grc
    lazygit
    neofetch
    ripgrep
    ruff
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
  programs.neovim = {
    enable = true;
  };
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
