{
  config,
  pkgs,
  lib,
  inputs,
  outputs,
  ...
}: {
  imports = [
    ./packages/ags
    ./packages/fish
    ./packages/firefox
    ./packages/git
    ./packages/kitty
    ./packages/helix
    ./packages/hyprland
    ./packages/hyprlock
    ./packages/nixvim
    ./packages/starship
    ./packages/wezterm
    ./packages/yazi
  ];
  home = {
    # Todo: change me to marliechiller in nixos
    username = "marliechiller";
    homeDirectory = "/Users/charliemiller";
    stateVersion = "23.11"; # Please read the comment before changing.
  };

  home.packages = with pkgs; [
    # NixOS specific packages

    # cli
    lshw
    traceroute
    wev

    # programs
    _1password-gui
    signal-desktop
    wireshark
  ];

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
  };

  systemd.user.startServices = "sd-switch";
}
