{
  config,
  pkgs,
  ...
}: {
  programs.fish = {
    # MacOS specific fish settings
    interactiveShellInit = ''
      # Add Nix profile to the $PATH, idempotent and only required for non-NixOS hosts.
      fish_add_path ~/.nix-profile/bin/
      fish_add_path /opt/homebrew/bin
    '';

    shellAliases = {};
    shellAbbrs = {
      nconfig = "z ~/Projects/nix";
      Projects = "z ~/Projects";
    };
  };
}
