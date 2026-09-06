{
  pkgs,
  config,
  ...
}: {
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

    # Automatic garbage collection. Only `automatic` and `options` are set here:
    # the schedule attribute differs per platform (`gc.interval` on darwin,
    # `gc.dates` on NixOS), so each is left at its default weekly/daily run.
    # Gated on `nix.enable` so this applies to home-darwin and home-nixos only.
    # work-darwin delegates nix to the Determinate Systems installer and sets
    # `nix.enable = false`, which makes these options unavailable there (both
    # modules assert `automatic -> nix.enable`); its GC is handled separately.
    gc = {
      automatic = config.nix.enable;
      options = "--delete-older-than 7d";
    };

    # Hardlink identical files in the store to reclaim duplicated space.
    optimise.automatic = config.nix.enable;
  };

  # Enable fish shell system-wide
  programs.fish.enable = true;
}
