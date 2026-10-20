{pkgs, ...}: {
  # Tailscale configuration for remote access

  # Enable Tailscale service
  services.tailscale = {
    enable = true;
    # Exit node: remote devices can route all traffic via home (public Wi-Fi,
    # UK services abroad). "server" enables IP forwarding; approve the route
    # once in the admin console.
    useRoutingFeatures = "server";
    extraSetFlags = ["--advertise-exit-node"];
  };

  # Ensure Tailscale starts on boot
  systemd.services.tailscaled.wantedBy = ["multi-user.target"];

  # Firewall configuration for Tailscale
  networking.firewall = {
    # Allow Tailscale through the firewall
    trustedInterfaces = ["tailscale0"];
    # Allow Tailscale UDP port
    allowedUDPPorts = [41641];
  };

  # Add Tailscale package
  environment.systemPackages = with pkgs; [
    tailscale
  ];
}
