{ config, pkgs, lib, inputs, outputs, ... }:

{
  imports = [
    ./packages/ags
    ./packages/fish
    ./packages/git
    ./packages/hyprland
    ./packages/hyprlock
    ./packages/nixvim
    ./packages/starship
    ./packages/wezterm
    ./packages/yazi
  ];
  nixpkgs.config.allowUnfree = true;

  news.display = "show";
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  #  home.users.marliechiller.shell = "zsh";

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home = {
    username = "marliechiller";
    homeDirectory = "/home/marliechiller";
    stateVersion = "23.11"; # Please read the comment before changing.
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.

  home.packages = with pkgs ; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    _1password-gui
    bat
    cargo
    curl
    erdtree
    eza
    fd
    firefox
    fzf
    helix
    htop
    google-chrome
    grc
    gcc
    lshw
    neofetch
    nextdns
    traceroute
    tree
    wev

    python3
    jetbrains.pycharm-professional
    ripgrep
    signal-desktop
    spotify

    # fish
    dolphin
    nerdfonts

    # nix
    cachix
    nil
    nix-info
    nixpkgs-fmt
    nixci
    nix-health

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" "CascadiaMono" "CascadiaCode" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];


  programs.nixvim.enable = true;
  programs.fzf.enable = true;


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
    # EDITOR = "emacs";
    EDITOR = "nvim";
  };

  systemd.user.startServices = "sd-switch";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
