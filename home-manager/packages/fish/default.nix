{ config, pkgs, ... }:

{
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
      { name = "grc"; src = pkgs.fishPlugins.grc.src; }
      { name = "sponge"; src = pkgs.fishPlugins.sponge.src; }
      # { name = "tide"; src = pkgs.fishPlugins.tide.src; }
      { name = "plugin-git"; src = pkgs.fishPlugins.plugin-git.src; }
      # Manually packaging and enable a plugin
      { name = "z"; src = pkgs.fishPlugins.z.src; }
    ];

    shellAliases = {
      "cp" = "cp -v";
      "ddf" = "df -h";
      "erd" = "erd -H";
      "mkdir" = "mkdir -p";
      "mv" = "mv -v";
      "rm" = "rm -v";

      "ld" = "eza -ld */ --no-quotes --time-style long-iso";
      "lla" = "eza -lah --no-quotes --time-style long-iso";
      "ll" = "eza -lh --no-quotes --time-style long-iso";
      "llr" = "eza -lhr --no-quotes --time-style long-iso";
      "lls" = "eza -lh -s size --no-quotes --time-style long-iso";
      "llt" = "eza -lh -s time --no-quotes --time-style long-iso";
      "lltr" = "eza -lhr -s time --no-quotes --time-style long-iso";

    };

    shellAbbrs = {
      nconfig = "z ~/.config/cfg-nix";
      # nix abbreviations
      ncg = "nix-collect-garbage";
      nhb = "home-manager switch --flake .#marliechiller@home-laptop";
      nrn = "sudo nixos-rebuild switch --flake .#home-laptop";
    };

  };
}

