{ ... }:
let
  users = import ../../../users.nix;
  userConfig = users.nixos;
in {
  imports = [
    ../../packages
  ];

  home = {
    username = userConfig.username;
    homeDirectory = "/home/${userConfig.username}";
    stateVersion = "24.11"; # Please read the comment before changing.
  };

  # Pass user config to all imported modules
  _module.args.userConfig = userConfig // { gitName = users.gitName; };
}
