{...}: {
  programs.fish = {
    # NixOS specific fish settings
    shellAbbrs = {
      nconfig = "z ~/.config/cfg-nix";
    };
  };
}
