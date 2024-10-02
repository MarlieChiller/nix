{
  config,
  pkgs,
  ...
}: {
  programs.fish = {
    # NixOS specific fish settings
    shellAliases = {};
    shellAbbrs = {
      nconfig = "z ~/.config/cfg-nix";
    };
  };
}
