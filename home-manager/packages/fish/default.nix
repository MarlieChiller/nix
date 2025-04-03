{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    fish
  ];

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      set -U fish_user_paths /opt/homebrew/bin/
      eval (/opt/homebrew/bin/brew shellenv)
      set -U fish_user_paths /usr/local/nvim/nvim-macos-arm64/bin $fish_user_paths
      op completion fish | source  # 1password autocomplete
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
      # "vim" = "nvim";
      gpass = "op item get google --vault Ocula --reveal --fields label=password | pbcopy";
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
