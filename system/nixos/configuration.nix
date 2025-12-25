{
  config,
  lib,
  pkgs,
  ...
}: let
  users = import ../../users.nix;
  userConfig = users.nixos;
in {
  imports = [
    ./hardware-configuration.nix
    ../common # system/common - shared across all systems
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "home-nixos";
  networking.networkmanager.enable = true;

  # Time zone and locale
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Stylix theming
  stylix = {
    enable = true;
    image = ../../home-manager/assets/wallpapers/mountain.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sizes = {
        terminal = 14;
      };
    };
  };

  # Enable the X11 windowing system
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Enable Sway (Wayland tiling window manager)
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "uk";

  # Enable sound with pipewire
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable SSH
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # Enable Tailscale for remote access
  services.tailscale = {
    enable = true;
    # Optional: Generate an auth key at https://login.tailscale.com/admin/settings/keys
    # and use it here to auto-authenticate on first boot
    # authKeyFile = "/path/to/auth-key-file";
  };

  # Ensure Tailscale starts on boot
  systemd.services.tailscaled.wantedBy = ["multi-user.target"];

  # Network routing configuration for Tailscale + ProtonVPN coexistence
  # Ensure Tailscale traffic bypasses ProtonVPN
  networking.firewall = {
    # Allow Tailscale through the firewall
    trustedInterfaces = ["tailscale0"];
    # Allow Tailscale UDP port
    allowedUDPPorts = [41641];
    # If you need to allow specific TCP ports for services, add them here
    # allowedTCPPorts = [ ... ];
  };

  # Define a user account
  users.users.${userConfig.username} = {
    isNormalUser = true;
    description = userConfig.username;
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIqaM3HaYC/wBPTOKMaK1wS21xiUtGdL74Bc/6yw95I9 macbook-to-nixos"
    ];
  };

  # NixOS-specific system packages
  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    htop
    tailscale
    protonvpn-cli
  ];

  # NixOS-specific nix configuration
  nix.settings = {
    auto-optimise-store = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports for Source Dedicated Server
  };

  # Enable GameMode for better gaming performance
  programs.gamemode.enable = true;

  # This is the initial NixOS release version from first install. Do not change.
  # See: https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "24.11";
}
