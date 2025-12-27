{pkgs, ...}: {
  # Tailscale configuration for remote access and exit node

  # Enable Tailscale service
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both"; # Enable subnet routing and exit node
    # Optional: Generate an auth key at https://login.tailscale.com/admin/settings/keys
    # and use it here to auto-authenticate on first boot
    # authKeyFile = "/path/to/auth-key-file";
  };

  # Ensure Tailscale starts on boot
  systemd.services.tailscaled.wantedBy = ["multi-user.target"];

  # Enable IP forwarding for exit node functionality
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  # Enable UDP GRO forwarding for better Tailscale performance
  boot.kernelModules = ["udp_tunnel"];
  systemd.services.tailscale-gro = {
    description = "Enable GRO forwarding for Tailscale";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.ethtool}/bin/ethtool -K enp2s0 rx-udp-gro-forwarding on rx-gro-list off";
      RemainAfterExit = true;
    };
  };

  # Firewall configuration for Tailscale
  networking.firewall = {
    # Allow Tailscale through the firewall
    trustedInterfaces = ["tailscale0"];
    # Allow Tailscale UDP port
    allowedUDPPorts = [41641];
  };

  # Add ethtool for GRO optimization
  environment.systemPackages = with pkgs; [
    tailscale
    ethtool
  ];
}
