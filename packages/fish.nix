{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    fish
  ];

  programs.fish = {

    enable = true;

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
      # nix abbreviations
      ncg = "nix-collect-garbage";
      nhb = "home-manager switch --flake .#marliechiller@nixos";
      nrn = "sudo nixos-rebuild switch --flake .#nixos";
    };

  };
}

