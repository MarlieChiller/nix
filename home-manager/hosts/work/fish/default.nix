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
          --ssh-flag="-L 6660:localhost:5432" \
          --ssh-flag="-N" \
          --zone="europe-west2-a"
      '';
      db_dev_ingestion = ''
        gcloud config set project ocula-platform-dev;
        gcloud compute ssh bastion-ingestion-dev-europe-west2 \
          --ssh-flag="-L 6661:localhost:5432" \
          --ssh-flag="-N" \
          --zone="europe-west2-a"
      '';
      db_dev_company_api = ''
        gcloud config set project ocula-platform-dev;
        gcloud compute ssh bastion-company-dev-europe-west2 \
          --ssh-flag="-L 6662:localhost:5432" \
          --ssh-flag="-N" \
          --zone="europe-west2-a"
      '';
      db_dev_copygen = ''
        gcloud config set project ocula-platform-dev;
        gcloud compute ssh bastion-boost-copy-dev-europe-west2 \
          --ssh-flag="-L 6663:localhost:5432" \
          --ssh-flag="-N" \
          --zone="europe-west2-a"
      '';
      db_dev_orchestration = ''
        gcloud config set project ocula-platform-dev;
        gcloud compute ssh bastion-workflow-dev-europe-west2 \
          --ssh-flag="-L 6664:localhost:5432" \
          --ssh-flag="-N" \
          --zone="europe-west2-a"
      '';
      # --- stg ---

      db_stg_big_boi = ''
        gcloud config set project ocula-platform-staging;
        gcloud compute ssh bastion-vm-staging-europe-west2 \
          --project ocula-platform-staging \
          --ssh-flag="-L 6650:localhost:5432" \
          --ssh-flag="-N" \
          --zone="europe-west2-a"
      '';
      db_stg_ingestion = ''
        gcloud config set project ocula-platform-staging;
        gcloud compute ssh bastion-ingestion-staging-europe-west2 \
          --ssh-flag="-L 6651:localhost:5432" \
          --ssh-flag="-N" \
          --zone="europe-west2-a"
      '';
      db_stg_company_api = ''
        gcloud config set project ocula-platform-staging;
        gcloud compute ssh bastion-company-staging-europe-west2 \
          --ssh-flag="-L 6652:localhost:5432" \
          --ssh-flag="-N" \
          --zone="europe-west2-a"
      '';
      db_stg_copygen = ''
        gcloud config set project ocula-platform-staging;
        gcloud compute ssh bastion-boost-copy-staging-europe-west2 \
          --ssh-flag="-L 6653:localhost:5432" \
          --ssh-flag="-N" \
          --zone="europe-west2-a"
      '';
      db_stg_orchestration = ''
        gcloud config set project ocula-platform-staging;
        gcloud compute ssh bastion-workflow-staging-europe-west2 \
          --ssh-flag="-L 6654:localhost:5432" \
          --ssh-flag="-N" \
          --zone="europe-west2-a"
      '';


      # --- prod ---

      db_prod_big_boi = ''
        gcloud config set project ocula-platform;
        gcloud compute ssh bastion-vm-prod-europe-west2 \
          --project ocula-platform \
          --ssh-flag="-L 6640:localhost:5432" \
          --ssh-flag="-N" \
          --zone="europe-west2-a"
      '';
      db_prod_company_api = ''
        gcloud config set project ocula-platform;
        gcloud compute ssh bastion-company-prod-europe-west2 \
          --ssh-flag="-L 6641:localhost:5432" \
          --ssh-flag="-N" \
          --zone="europe-west2-a"
      '';
      db_prod_ingestion = ''
        gcloud config set project ocula-platform;
        gcloud compute ssh bastion-ingestion-prod-europe-west2 \
          --ssh-flag="-L 6642:localhost:5432" \
          --ssh-flag="-N" \
          --zone="europe-west2-a"
      '';
      db_prod_copy_gen = ''
        gcloud config set project ocula-platform;
        gcloud compute ssh bastion-boost-copy-prod-europe-west2 \
          --ssh-flag="-L 6643:localhost:5432" \
          --ssh-flag="-N" \
          --zone="europe-west2-a"
      '';
      db_prod_orchestration = ''
        gcloud config set project ocula-platform;
        gcloud compute ssh bastion-workflow-prod-europe-west2 \
          --ssh-flag="-L 6644:localhost:5432" \
          --ssh-flag="-N" \
          --zone="europe-west2-a"
      '';
    };
    functions = {
      dev_start_and_kill_ssh_tunnels = ''
        set -l pids

        function start_tunnel
            set -l label $argv[1]
            set -l command $argv[2]

            echo "Starting $label..."
            eval $command &
            set -a pids $last_pid
        end

        start_tunnel db_dev_big_boi 'gcloud config set project ocula-platform-dev; gcloud compute ssh bastion-vm-dev-europe-west2 --project ocula-platform-dev --ssh-flag="-L 6660:localhost:5432" --ssh-flag="-N" --zone="europe-west2-a"'
        start_tunnel db_dev_ingestion 'gcloud config set project ocula-platform-dev; gcloud compute ssh bastion-ingestion-dev-europe-west2 --ssh-flag="-L 6661:localhost:5432" --ssh-flag="-N" --zone="europe-west2-a"'
        start_tunnel db_dev_company_api 'gcloud config set project ocula-platform-dev; gcloud compute ssh bastion-company-dev-europe-west2 --ssh-flag="-L 6662:localhost:5432" --ssh-flag="-N" --zone="europe-west2-a"'
        start_tunnel db_dev_copygen 'gcloud config set project ocula-platform-dev; gcloud compute ssh bastion-boost-copy-dev-europe-west2 --ssh-flag="-L 6663:localhost:5432" --ssh-flag="-N" --zone="europe-west2-a"'
        start_tunnel db_dev_orchestration 'gcloud config set project ocula-platform-dev; gcloud compute ssh bastion-workflow-dev-europe-west2 --ssh-flag="-L 6664:localhost:5432" --ssh-flag="-N" --zone="europe-west2-a"'

        echo "All tunnels started. Press Enter to terminate them."
        read

        for pid in $pids
            echo "Killing PID $pid"
            kill $pid
        end

        echo "All tunnels terminated."
      '';
    };
  };
}
