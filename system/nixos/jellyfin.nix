{
  config,
  lib,
  pkgs,
  ...
}: let
  users = import ../../users.nix;
  userConfig = users.nixos;
in {
  # Jellyfin media server
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = userConfig.username;
    group = "users";
    dataDir = "/home/${userConfig.username}/.jellyfin";
    cacheDir = "/home/${userConfig.username}/.cache/jellyfin";
  };

  # Give Jellyfin access to GPU for hardware transcoding
  systemd.services.jellyfin.serviceConfig = {
    SupplementaryGroups = ["render" "video"];
    DeviceAllow = ["/dev/dri/renderD128"];
  };
}
