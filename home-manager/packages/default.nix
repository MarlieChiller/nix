# common configuration across all system
{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: {
  imports = [
    ./aerospace
    ./atuin
    ./bat
    ./fish
    ./git
    ./jujutsu
    ./kitty
    ./helix
    ./nixvim
    ./starship
    ./ssh
    ./sway
    ./wezterm
    ./yazi
  ];

  news.display = "show";

  home.packages = with pkgs;
    [
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
      gping
      gh
      grc
      jujutsu
      just
      lazygit
      ripgrep
      ruff
      tre-command
      uv
      yazi

      # gui
      firefox

      # nix
      alejandra
      cachix
      nil
      nix-info
      nixci
      nix-health
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      # darwin-only packages
      jankyborders
    ];

  programs.fzf.enable = true;
  programs.fish.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager = {
    enable = true;
    # backupFileExtension = true;
  };

  # Copy GUI apps to ~/Applications for Spotlight/Alfred discovery (macOS only)
  targets.darwin = lib.mkIf pkgs.stdenv.isDarwin {
    linkApps.enable = false; # Disable old symlink-based approach
    copyApps.enable = true; # Enable new copy-based approach (works with Spotlight)
  };
}
