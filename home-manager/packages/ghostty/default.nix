{pkgs, ...}: {
  programs.ghostty = {
    enable = true;
    # macOS installs Ghostty via Homebrew cask; Linux gets it from nixpkgs
    # (a null package there trips the programs.ghostty.systemd assertion).
    package =
      if pkgs.stdenv.isDarwin
      then null
      else pkgs.ghostty;
    settings = {
      command = "${pkgs.fish}/bin/fish";
    };
  };
}
