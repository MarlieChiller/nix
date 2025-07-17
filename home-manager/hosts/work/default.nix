{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../../packages
    ./fish
    #    inputs.mac-app-util.homeManagerModules.default
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
    # installs gcloud with extra components like kubectl
    (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.kubectl])
    terraform
  ];
}
