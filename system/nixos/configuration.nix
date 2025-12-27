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
    ./tailscale.nix
    ../common # system/common - shared across all systems
  ];

  # Bootloader (GRUB for BIOS/Legacy boot)
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda"; # Install GRUB to MBR
  };

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
    image = ../../home-manager/assets/wallpapers/leaves.jpg;
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
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

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

  # keyd - Remap Caps Lock to Meh (Ctrl+Alt+Shift)
  # This matches the Aerospace configuration on macOS
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = ["*"];
        settings = {
          main = {
            # Caps Lock becomes Meh modifier (Ctrl+Alt+Shift)
            capslock = "layer(meh)";
          };
          # Meh layer: Ctrl+Alt+Shift (matching Aerospace)
          "meh:C-A-S" = {};
        };
      };
    };
  };

  # Enable sound with pipewire
  services.pulseaudio.enable = false;
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

  # Enable 1Password desktop and SSH agent
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [userConfig.username];
  };

  # NixOS-specific system packages
  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    htop
    protonvpn-gui
    _1password-cli
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
    # Fix mouse sensitivity issues in XWayland
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  # Steam environment variables for better Wayland/XWayland support
  environment.sessionVariables = {
    STEAM_FORCE_DESKTOPUI_SCALING = "1";
  };

  # Enable GameMode for better gaming performance
  programs.gamemode.enable = true;

  # This is the initial NixOS release version from first install. Do not change.
  # See: https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "24.11";
}
