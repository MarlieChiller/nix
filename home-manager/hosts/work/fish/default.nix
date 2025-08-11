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
      set -U fish_user_paths /Users/charlie.miller/.local/bin $fish_user_paths
      set -U fish_user_paths /opt/homebrew/opt/postgresql/bin $fish_user_paths

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
    };
    functions = {};
  };
}
