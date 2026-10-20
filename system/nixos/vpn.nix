{...}: {
  # Route only qBittorrent through Proton VPN, in its own network namespace
  # with a kill switch: if the tunnel drops, torrents stop rather than leak.
  # Jellyfin, Tailscale, Steam etc. stay on the normal connection.
  #
  # The WireGuard config holds a private key, so it lives outside the repo:
  #   sudo install -Dm600 ~/Downloads/<proton-config>.conf /etc/secrets/proton-wg.conf
  # Download it from a P2P server (Proton blocks torrents on the others).
  # Not "proton": the Proton VPN app already uses the proton0 interface name
  vpnNamespaces.torrent = {
    enable = true;
    # A string, not a path literal, so the key is never copied into the store
    wireguardConfigFile = "/etc/secrets/proton-wg.conf";
    # Opens the web UI inside the namespace (it drops all other inbound).
    # With accessibleFrom empty, replies to the LAN go via the tunnel and
    # fail, so this stays reachable from this machine only.
    portMappings = [
      {
        from = 8080;
        to = 8080;
      }
    ];
  };

  # Web UI is only reachable from this machine, at the namespace address:
  # http://192.168.15.1:8080
  systemd.services.qbittorrent.vpnConfinement = {
    enable = true;
    vpnNamespace = "torrent";
  };
}
