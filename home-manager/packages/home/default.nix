{ pkgs, ... }:
{
  home.packages = with pkgs; [
    discord
    obsidian
    steam
  ];

}
