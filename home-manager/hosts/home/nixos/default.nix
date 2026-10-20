{
  userConfig,
  pkgs,
  ...
}: {
  # Packages and userConfig passed from flake level

  home = {
    username = userConfig.username;
    homeDirectory = "/home/${userConfig.username}";
    stateVersion = "24.11"; # Please read the comment before changing.

    packages = with pkgs; [
      # Photo editing
      darktable
      krita

      # wl-copy/wl-paste: fish's Ctrl+V/Ctrl+X and Neovim's clipboard need them on Wayland
      wl-clipboard
    ];
  };
}
