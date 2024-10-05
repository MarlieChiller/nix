{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.ags.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    brightnessctl
    bun
    dart-sass
    gtk3
    hyprpicker
    inputs.matugen.packages.${system}.default
    networkmanager
    pavucontrol
    swappy
    swww
    wayshot
    wf-recorder
    wl-clipboard
  ];

  programs.ags = {
    enable = true;
    configDir = ../../../hosts/nixos/ags;
    extraPackages = with pkgs; [
      accountsservice
    ];
  };
}
