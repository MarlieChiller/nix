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
    dataDir = "/var/lib/jellyfin";
    cacheDir = "/var/cache/jellyfin";
  };

  # Give Jellyfin access to GPU for hardware transcoding and media directories
  systemd.services.jellyfin.serviceConfig = {
    SupplementaryGroups = ["render" "video"];
    DeviceAllow = ["/dev/dri/renderD128"];
    ReadWritePaths = ["/mnt/storage/media" "/srv/media"]; # New HDD storage + legacy path
  };
}
