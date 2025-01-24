{
  config,
  pkgs,
  ...
}: {
  programs.fish = {
    # MacOS specific fish settings
    shellInit = '''';
    interactiveShellInit = ''
      # Add Nix profile to the $PATH, idempotent and only required for non-NixOS system.
      fish_add_path ~/.nix-profile/bin/
      fish_add_path /opt/homebrew/bin
      set -U fish_user_paths /Users/charliemiller/.local/bin $fish_user_paths
      set -U fish_user_paths /opt/homebrew/opt/postgresql/bin $fish_user_paths
      set -Ux PYENV_ROOT $HOME/.pyenv
      set -U fish_user_paths $PYENV_ROOT/bin $fish_user_paths
      pyenv init - | source

      # stupid postgres stuff
      set -U fish_user_paths /opt/homebrew/opt/openssl/bin /opt/homebrew/opt/libpq/bin /opt/homebrew/opt/zlib/bin $fish_user_paths
      set -x LDFLAGS "-L/opt/homebrew/opt/openssl/lib -L/opt/homebrew/opt/zlib/lib"
      set -x CPPFLAGS "-I/opt/homebrew/opt/openssl/include -I/opt/homebrew/opt/zlib/include"
      set -x PKG_CONFIG_PATH "/opt/homebrew/opt/openssl/lib/pkgconfig:/opt/homebrew/opt/zlib/lib/pkgconfig"
    '';

    shellAliases = {};
    shellAbbrs = {
      dstop = "docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)";
      nconfig = "z ~/Projects/nix";
      Projects = "z ~/Projects";

      # --- dev ---

      db_dev_big_boi = ''
        gcloud config set project ocula-platform-dev;
        gcloud compute ssh bastion-vm-dev-europe-west2 \
          --project ocula-platform-dev \
          --ssh-flag="-L 6666:localhost:5432" \
          --ssh-flag="-N" \
          --zone="europe-west2-a"
      '';
      db_dev_ingestion = ''
        gcloud config set project ocula-platform-dev;
        gcloud compute ssh bastion-ingestion-dev-europe-west2 \
          --ssh-flag="-L 6666:localhost:5432" \
          --ssh-flag="-N" \
          --zone="europe-west2-a"
      '';
      db_dev_company_api = ''
        gcloud config set project ocula-platform-dev;
        gcloud compute ssh bastion-company-dev-europe-west2 \
          --ssh-flag="-L 6666:localhost:5432" \
          --ssh-flag="-N" \
          --zone="europe-west2-a"
      '';

      # --- stg ---

      db_stg_big_boi = ''
        gcloud config set project ocula-platform-staging;
        gcloud compute ssh bastion-vm-staging-europe-west2 \
          --project ocula-platform-staging \
          --ssh-flag="-L 6666:localhost:5432" \
          --ssh-flag="-N" \
          --zone="europe-west2-a"
      '';
      db_stg_ingestion = ''
        gcloud config set project ocula-platform-staging;
        gcloud compute ssh bastion-ingestion-staging-europe-west2 \
          --ssh-flag="-L 6666:localhost:5432" \
          --ssh-flag="-N" \
          --zone="europe-west2-a"
      '';
      db_stg_company_api = ''
        gcloud config set project ocula-platform-staging;
        gcloud compute ssh bastion-company-staging-europe-west2 \
          --ssh-flag="-L 6666:localhost:5432" \
          --ssh-flag="-N" \
          --zone="europe-west2-a"
      '';

      # --- prod ---

      db_prod_big_boi = ''
        gcloud config set project ocula-platform;
        gcloud compute ssh bastion-vm-prod-europe-west2 \
          --project ocula-platform \
          --ssh-flag="-L 6666:localhost:5432" \
          --ssh-flag="-N" \
          --zone="europe-west2-a"
      '';
      db_prod_company_api = ''
        gcloud config set project ocula-platform;
        gcloud compute ssh bastion-company-prod-europe-west2 \
          --ssh-flag="-L 6666:localhost:5432" \
          --ssh-flag="-N" \
          --zone="europe-west2-a"
      '';
      db_prod_ingestion = ''
        gcloud config set project ocula-platform;
        gcloud compute ssh bastion-ingestion-prod-europe-west2 \
          --ssh-flag="-L 6666:localhost:5432" \
          --ssh-flag="-N" \
          --zone="europe-west2-a"
      '';
    };
  };
}
