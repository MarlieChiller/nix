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
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "home-desktop";
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

  # Enable Stylix for consistent theming
  stylix = {
    enable = true;
    image = ../../home-manager/assets/wallpapers/mountain.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.hack;
        name = "Hack Nerd Font Mono";
      };
      sizes = {
        terminal = 14;
      };
    };
  };

  # Enable the X11 windowing system
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment (you can change this)
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

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
  systemd.services.tailscaled.wantedBy = [ "multi-user.target" ];

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

  # System packages
  environment.systemPackages = with pkgs; [
    vim
    fish
    git
    wget
    curl
    htop
    tailscale
  ];

  # Enable nix flakes
  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Enable fish shell
  programs.fish.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "24.11";
}
