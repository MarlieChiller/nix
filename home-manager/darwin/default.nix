{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../common
    ./fish
    inputs.mac-app-util.homeManagerModules.default
  ];

  home = {
    username = "charliemiller";
    homeDirectory = "/Users/charliemiller";
    stateVersion = "23.11"; # Please read the comment before changing.
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.

  home.packages = with pkgs; [
    # MacOS specific home manager packages
    google-cloud-sdk
    poetry
    terraform
  ];
}
