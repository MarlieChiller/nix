{ ... }:
let
  users = import ../../../users.nix;
  userConfig = users.home;
in {
  imports = [
    ../../packages
  ];

  home = {
    username = userConfig.username;
    homeDirectory = "/Users/${userConfig.username}";
    stateVersion = "23.11"; # Please read the comment before changing.
  };

  # Pass user config to all imported modules
  _module.args.userConfig = userConfig // { gitName = users.gitName; };
}
