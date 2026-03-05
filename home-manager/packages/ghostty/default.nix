{pkgs, ...}: {
  programs.ghostty = {
    enable = true;
    package = null; # Installed via Homebrew cask
    settings = {
      command = "${pkgs.fish}/bin/fish";
    };
  };
}
