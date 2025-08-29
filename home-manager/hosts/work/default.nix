{
  pkgs,
  inputs,
  ...
}: let
  users = import ../../../users.nix;
  userConfig = users.work;
in {
  imports = [
    ../../packages
    ../../packages/granted
    ./fish
    #    inputs.mac-app-util.homeManagerModules.default
  ];

  home = {
    username = userConfig.username;
    homeDirectory = "/Users/${userConfig.username}";
    stateVersion = "23.11"; # Please read the comment before changing.
  };

  # Pass user config to all imported modules
  _module.args.userConfig = userConfig // {gitName = users.gitName;};

  # The home.packages option allows you to install Nix packages into your
  # environment.

  home.packages = with pkgs; [
    # MacOS specific home manager packages
    awscli2
    terraform
    kubernetes-helm
  ];
}
