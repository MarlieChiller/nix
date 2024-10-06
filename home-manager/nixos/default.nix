{
  config,
  pkgs,
  lib,
  inputs,
  outputs,
  ...
}: {
  imports = [
    ./ags
    ./firefox
    ./fish
    ./hyprland
    ./hyprlock
    ../common
  ];
  home = {
    username = "marliechiller";
    homeDirectory = "/home/marliechiller";
    stateVersion = "23.11"; # Please read the comment before changing.
  };

  home.packages = with pkgs; [
    # NixOS specific packages
    dolphin
    spotifywm

    # cli
    fd
    lshw
    traceroute
    wev

    # programs
    _1password-gui
    google-chrome
    plex
    protonvpn-gui
    signal-desktop
    qbittorrent
    vlc
    wireshark

  ];

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
  };

  systemd.user.startServices = "sd-switch";
}
