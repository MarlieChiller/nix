{
  config,
  pkgs,
  ...
}: {
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
  systemd.services.qbittorrent = {
    vpnConfinement = {
      enable = true;
      vpnNamespace = "torrent";
    };
    # The port-forward helper talks to the API from inside the namespace, so
    # skip auth for localhost (only the namespace; the host still needs the
    # password). Edited in place so settings made in the web UI survive.
    preStart = ''
      conf="${config.services.qbittorrent.profileDir}/qBittorrent/config/qBittorrent.conf"
      mkdir -p "$(dirname "$conf")"
      touch "$conf"
      if grep -q '^WebUI\\LocalHostAuth=' "$conf"; then
        sed -i 's/^WebUI\\LocalHostAuth=.*/WebUI\\LocalHostAuth=false/' "$conf"
      elif grep -q '^\[Preferences\]' "$conf"; then
        sed -i '/^\[Preferences\]/a WebUI\\LocalHostAuth=false' "$conf"
      else
        printf '\n[Preferences]\nWebUI\\LocalHostAuth=false\n' >> "$conf"
      fi
    '';
  };

  # Proton port forwarding (NAT-PMP) so peers can connect in. Proton hands
  # out a port per session and drops it unless renewed within 60s, so this
  # loop renews it, opens it on the tunnel and points qBittorrent at it.
  # Needs a config downloaded with "NAT-PMP (Port Forwarding)" on.
  systemd.services.proton-port-forward = {
    description = "Proton VPN port forwarding for qBittorrent";
    after = ["qbittorrent.service"];
    wantedBy = ["multi-user.target"];
    vpnConfinement = {
      enable = true;
      vpnNamespace = "torrent";
    };
    path = with pkgs; [libnatpmp iptables curl gnused];
    serviceConfig = {
      Restart = "always";
      RestartSec = 30;
    };
    script = ''
      # Own chain so a port change only has to flush our rules
      iptables -N port-fwd 2>/dev/null || true
      iptables -C INPUT -j port-fwd 2>/dev/null || iptables -I INPUT -j port-fwd

      current=""
      while true; do
        out=$(natpmpc -g 10.2.0.1 -a 1 0 udp 60 && natpmpc -g 10.2.0.1 -a 1 0 tcp 60) || {
          echo "NAT-PMP request failed: was the WireGuard config downloaded with port forwarding on?" >&2
          exit 1
        }
        port=$(echo "$out" | sed -n 's/.*Mapped public port \([0-9]*\).*/\1/p' | tail -n1)

        if [ -n "$port" ] && [ "$port" != "$current" ]; then
          iptables -F port-fwd
          iptables -A port-fwd -i torrent0 -p tcp --dport "$port" -j ACCEPT
          iptables -A port-fwd -i torrent0 -p udp --dport "$port" -j ACCEPT
          if curl -sf --data-urlencode "json={\"listen_port\":$port}" \
            http://127.0.0.1:8080/api/v2/app/setPreferences; then
            echo "Forwarding port $port"
            current=$port
          else
            echo "Couldn't set qBittorrent's port to $port; is it running with localhost auth bypass on?" >&2
          fi
        fi
        sleep 45
      done
    '';
  };
}
