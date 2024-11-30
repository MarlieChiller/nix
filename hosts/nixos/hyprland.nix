{
  pkgs,
  inputs,
  ...
}: {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  programs.nm-applet.enable = true;
  environment.systemPackages = with pkgs; [
    libnotify
    networkmanagerapplet

    # from https://github.com/Aylur/dotfiles/blob/main/nixos/hyprland.nix
    morewaita-icon-theme
    adwaita-icon-theme
    qogir-icon-theme
    loupe
    nautilus
    baobab
    blueman
    gnome-text-editor
    gnome-calendar
    gnome-boxes
    gnome-system-monitor
    gnome-control-center
    gnome-weather
    gnome-calculator
    gnome-clocks
    gnome-software # for flatpak
    wl-gammactl
    wl-clipboard
    wayshot
    pavucontrol
    brightnessctl
    swww

    inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
  ];
  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };
  services = {
    udisks2.enable = true;
    upower.enable = true;
    power-profiles-daemon.enable = true;
    accounts-daemon.enable = true;
    gnome = {
      evolution-data-server.enable = true;
      glib-networking.enable = true;
      gnome-keyring.enable = true;
      gnome-online-accounts.enable = true;
      tinysparql.enable = true;
      localsearch.enable = true;
    };
  };
}
