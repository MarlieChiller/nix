{
  pkgs,
  inputs,
  userConfig,
  ...
}: {
  # All imports and userConfig passed from flake level

  home = {
    username = userConfig.username;
    homeDirectory = "/Users/${userConfig.username}";
    stateVersion = "23.11"; # Please read the comment before changing.
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.

  home.packages = with pkgs; [
    # MacOS specific home manager packages
    awscli2
    dbeaver-bin
    k9s
    kubectl
    kubernetes-helm
    mise
    stern
    terraform
  ];
}
