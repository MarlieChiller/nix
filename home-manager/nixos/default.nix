{pkgs, ...}: {
  imports = [
    ../common
    ./ags
    ./firefox
    ./fish
    ./hyprland
    ./hyprlock
  ];
  home = {
    username = "marliechiller";
    homeDirectory = "/home/marliechiller";
    stateVersion = "23.11"; # do not change
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
    signal-desktop
    wireshark
  ];

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
  };

  systemd.user.startServices = "sd-switch";
}
