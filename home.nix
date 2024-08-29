{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "marliechiller";
  home.homeDirectory = "/home/marliechiller";
#  home.users.marliechiller.shell = "zsh";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs ; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    _1password-gui
    cargo
    curl
    discord
    firefox
    fzf
    htop
    lazyvim
    lshw
    nextdns
    neofetch
    wev
    wezterm

    python3
    ripgrep
    signal-desktop
    spotify

    # fish
    fish
    dolphin
    grc
    nerdfonts
    zoxide

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  programs.git = {
    enable = true;
    userName = "MarlieChiller";
    userEmail = "marliechiller@proton.me";

    extraConfig.github.user = "MarlieChiller";
  };
  
  programs.firefox.enable = true;


  programs.fzf.enable = true;
  programs.fzf.enableZshIntegration = true;

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    plugins = [
      # Enable a plugin (here grc for colorized command output) from nixpkgs
      { name = "grc"; src = pkgs.fishPlugins.grc.src; }
      { name = "sponge"; src = pkgs.fishPlugins.sponge.src; }
      # { name = "tide"; src = pkgs.fishPlugins.tide.src; }
      { name = "plugin-git"; src = pkgs.fishPlugins.plugin-git.src; }
      # Manually packaging and enable a plugin
      { name = "z"; src = pkgs.fishPlugins.z.src; }
    ];
    shellAliases = {
      vi = "lvim";
      vim = "lvim";
      hm_edit = "$EDITOR /home/marliechiller/.config/home-manager/home.nix";
      nx_edit = "sudo $EDITOR /etc/nixos/configuration.nix";
      };
  };


  services.hyprpaper = {
    enable = true;
    settings.preload = ["~/Pictures/wallpapers/wallpaper.jpg"];
    settings.wallpaper = [
      "DP-1,~/Pictures/wallpapers/wallpaper.jpg"
      "eDP-1,~/Pictures/wallpapers/wallpaper.jpg"
      "HDMI-A-1,~/Pictures/wallpapers/wallpaper.jpg"
    ];
  };

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
    EDITOR = "lvim";
  };


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
