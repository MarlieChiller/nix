{userConfig, ...}: {
  # Packages and userConfig passed from flake level

  home = {
    username = userConfig.username;
    homeDirectory = "/home/${userConfig.username}";
    stateVersion = "24.11"; # Please read the comment before changing.
  };
}
