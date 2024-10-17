{
  config,
  pkgs,
  lib,
  inputs,
  outputs,
  ...
}: {
  imports = [
    ../common
    ./fish
    ./aerospace
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
    terraform

    # ui
    jankyborders
    sketchybar
  ];
}
