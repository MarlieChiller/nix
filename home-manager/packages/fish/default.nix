{
  config,
  pkgs,
  ...
}: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      set -U fish_user_paths /opt/homebrew/bin/
      eval (/opt/homebrew/bin/brew shellenv)
      set -U fish_user_paths /usr/local/nvim/nvim-macos-arm64/bin $fish_user_paths
      # 1password autocomplete with timeout to prevent hanging
      if command -q op
        timeout 2s op completion fish | source 2>/dev/null
      end
      
      # atuin shell with timeout to prevent hanging  
      if command -q atuin
        timeout 2s atuin init fish | source 2>/dev/null
      end

      # direnv integration
      if command -q direnv
        direnv hook fish | source
      end

      # Enable vim bindings
      fish_vi_key_bindings

      # Alt+v: open current command in $EDITOR, then return to the prompt
      bind -M insert \ev edit_command_buffer
    '';
    plugins = [
      # Enable a plugin (here grc for colorized command output) from nixpkgs
      {
        name = "grc";
        src = pkgs.fishPlugins.grc.src;
      }
      {
        name = "sponge";
        src = pkgs.fishPlugins.sponge.src;
      }
      {
        name = "plugin-git";
        src = pkgs.fishPlugins.plugin-git.src;
      }
      {
        name = "z";
        src = pkgs.fishPlugins.z.src;
      }
    ];

    shellAliases = {};

    shellAbbrs = {
      # nix abbreviations
      "vim" = "nvim";
      nconfig = "z ~/Projects/nix";
      Projects = "z ~/Projects";
      ncg = "nix-collect-garbage";
      cp = "cp -v";
      ddf = "df -h";
      erd = "erd -H";
      mkdir = "mkdir -p";
      mv = "mv -v";
      rm = "rm -v";
      ld = "eza -ld */ --no-quotes --time-style long-iso";
      lla = "eza -lah --no-quotes --time-style long-iso";
      ll = "eza -lh --no-quotes --time-style long-iso";
      llr = "eza -lhr --no-quotes --time-style long-iso";
      lls = "eza -lh -s size --no-quotes --time-style long-iso";
      llt = "eza -lh -s time --no-quotes --time-style long-iso";
      lltr = "eza -lhr -s time --no-quotes --time-style long-iso";
      gacam = "git add . && git commit --amend && git push --force-with-lease origin";
    };
  };
}
