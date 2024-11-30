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

    shellAliases = {
      "vim" = "nvim";
    };

    shellAbbrs = {
      # nix abbreviations
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
