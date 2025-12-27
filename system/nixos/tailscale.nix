{pkgs, ...}: {
  # Tailscale configuration for remote access

  # Enable Tailscale service
  services.tailscale = {
    enable = true;
    # Use default routing (client mode only, no exit node or subnet routing)
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
