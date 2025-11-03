{
  config,
  pkgs,
  userConfig,
  ...
}: {
  programs.fish = {
    # MacOS specific fish settings
    shellInit = '''';
    interactiveShellInit = ''
      # Add Nix profile to the $PATH, idempotent and only required for non-NixOS system.
      fish_add_path ~/.nix-profile/bin/
      fish_add_path /opt/homebrew/bin
      set -U fish_user_paths /Users/${userConfig.username}/.local/bin $fish_user_paths
      set -U fish_user_paths /opt/homebrew/opt/postgresql/bin $fish_user_paths

      # stupid postgres stuff
      set -U fish_user_paths /opt/homebrew/opt/openssl/bin /opt/homebrew/opt/libpq/bin /opt/homebrew/opt/zlib/bin $fish_user_paths
      set -x LDFLAGS "-L/opt/homebrew/opt/openssl/lib -L/opt/homebrew/opt/zlib/lib"
      set -x CPPFLAGS "-I/opt/homebrew/opt/openssl/include -I/opt/homebrew/opt/zlib/include"
      set -x PKG_CONFIG_PATH "/opt/homebrew/opt/openssl/lib/pkgconfig:/opt/homebrew/opt/zlib/lib/pkgconfig"

      # uv keyring authentication for AWS CodeArtifact
      # Note: Run `uv tool install keyring --with keyrings.codeartifact` to install keyring
      set -x UV_KEYRING_PROVIDER subprocess
      set -x UV_INDEX_ZEGO_USERNAME aws
      set -x POETRY_HTTP_BASIC_ZEGO_USERNAME aws
    '';

    shellAliases = {};
    shellAbbrs = {
      dstop = "docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)";
      nconfig = "z ~/Projects/nix";
      Projects = "z ~/Projects";
    };
    functions = {
      set_artifact_token = ''
        set -l token (artifact_token)
        set -gx POETRY_HTTP_BASIC_ZEGO_PASSWORD $token
        set -gx UV_INDEX_ZEGO_PASSWORD $token
      '';
      artifact_token = ''
        aws codeartifact get-authorization-token \
            --domain zego \
            --domain-owner 197161164104 \
            --region eu-west-1 \
            --query authorizationToken \
            --output text | string replace -r '\n$' ""
      '';
      copy_artifact_token = ''
        set token (artifact_token)
        printf "%s" $token | pbcopy
        echo "🔑 CodeArtifact token copied to clipboard."
      '';
      knines = ''
        assume staging.developer-nonprod
        aws eks update-kubeconfig --name staging
        k9s
      '';
      unset_aws = ''
        set -e AWS_ACCESS_KEY_ID
        set -e AWS_SECRET_ACCESS_KEY
        set -e AWS_SESSION_TOKEN
        set -e AWS_PROFILE
        set -e AWS_REGION
        set -e AWS_DEFAULT_REGION
      '';
    };
  };
}
