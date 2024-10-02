# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  inputs,
  outputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./hyprland.nix
    ./nvidia.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "home-laptop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Enable zsa keyboard flashing
  hardware.keyboard.zsa.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
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
  services.resolved = {
    enable = true;
    extraConfig = ''
      DNS=45.90.28.0#661869.dns.nextdns.io
      DNS=2a07:a8c0::#661869.dns.nextdns.io
      DNS=45.90.30.0#661869.dns.nextdns.io
      DNS=2a07:a8c1::#661869.dns.nextdns.io
      DNSOverTLS=yes
    '';
  };

  # Enable the KDE Plasma Desktop Environment.
  # services.desktopManager.plasma6.enable = true;
  # services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.wayland.enable = true;
  # services.displayManager.defaultSession = "plasma";

  # services.greetd = {
  #   enable = true;
  #   settings = {
  #     default_session = {
  #       command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd hyprland";
  #       user = "greeter";
  #     };
  #   };
  # };

  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.options = "caps:super";
    xkb.variant = "";
    # Load nvidia driver for Xorg and Wayland
    videoDrivers = ["nvidia"];
  };
  # displayManager.gdm = {
  #   enable = true;
  #   wayland = true;
  # };

  # Configure console keymap
  console.keyMap = "uk";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  hardware.pulseaudio.enable = false;
  security = {
    rtkit.enable = true;
    polkit.enable = true;
    pam.services.hyprlock = {};
  };
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
    wireplumber.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.marliechiller = {
    isNormalUser = true;
    description = "MarlieChiller";
    extraGroups = ["networkmanager" "wheel" "audio"];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJvT8OYoGidygyDAhEC6M7XiDNFy5DZ1eSn256uAqHPa"
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    git
    home-manager
    vim
  ];

  # https://nixos.org/manual/nixos/stable/options.html#opt-nix.settings.allowed-users
  nix = {
    settings = {
      allowed-users = ["marliechiller"];
      experimental-features = ["nix-command" "flakes"];
    };
    # Enable nix garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment? }
}
