# common configuration across all hosts
{pkgs, ...}: {
  imports = [
    ./bat
    ./fish
    ./git
    ./kitty
    ./helix
    ./nixvim
    ./starship
    ./stylix
    ./wezterm
    ./yazi
  ];
  nixpkgs.config.allowUnfree = true;

  news.display = "show";
  # Home Manager needs a bit of information about you and the paths it should manage.

  nix = {
    package = pkgs.nix;
    settings.experimental-features = ["nix-command" "flakes"];
  };

  home.packages = with pkgs; [
    # cli
    btop
    cargo
    curl
    erdtree
    eza
    fd
    fish
    fzf
    gcc
    grc
    lazygit
    neofetch
    nextdns
    # pyenv
    ripgrep
    ruff

    # nix
    alejandra
    cachix
    nil
    nix-info
    nixci
    nix-health
  ];

  programs.nixvim.enable = true;
  programs.fzf.enable = true;
  programs.fish.enable = true;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/marliechiller/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
