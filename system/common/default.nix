{pkgs, ...}: {
  # Shared configuration for both Darwin and NixOS systems

  # Basic system packages available on all systems
  environment.systemPackages = [
    pkgs.vim
    pkgs.fish
  ];

  # Nix package manager configuration
  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = ["nix-command" "flakes"];
    };
  };

  # Enable fish shell system-wide
  programs.fish.enable = true;
}
