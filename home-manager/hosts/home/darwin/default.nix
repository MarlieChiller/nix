{userConfig, ...}: {
  # Packages and userConfig passed from flake level

  home = {
    username = userConfig.username;
    homeDirectory = "/Users/${userConfig.username}";
    stateVersion = "23.11"; # Please read the comment before changing.
  };
}
