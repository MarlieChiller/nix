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
      dev_boost_db = ''
        gcloud config set project ocula-platform-dev;
        gcloud compute ssh bastion-vm-dev-europe-west2 \
          --project ocula-platform-dev \
          --ssh-flag="-L 6666:localhost:5432" \
          --ssh-flag="-N" \
          --zone="europe-west2-a"
      '';
      dev_ingestion_db = ''
        gcloud config set project ocula-platform-dev;
        gcloud compute ssh bastion-ingestion-dev-europe-west2 \
          --ssh-flag="-L 6666:localhost:5432" \
          --ssh-flag="-N" \
          --zone="europe-west2-a"
      '';
    };
  };
}
