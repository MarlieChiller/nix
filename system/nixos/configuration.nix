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
    ./jellyfin.nix
    ../common # system/common - shared across all systems
  ];

  # Bootloader (GRUB for BIOS/Legacy boot)
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda"; # Install GRUB to MBR
  };

  networking.hostName = "home-nixos";
  networking.networkmanager.enable = true;

  services.nextdns = {
    enable = true;
    arguments = ["-config" "661869"];
  };

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
    # Enable Qt styling for KDE Plasma
    targets.qt.enable = true;
  };

  # Enable AMD graphics drivers for hardware acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # For 32-bit applications (gaming, Steam, etc.)
    extraPackages = with pkgs; [
      # RADV (Mesa Vulkan driver) is enabled by default
      rocmPackages.clr.icd # OpenCL driver for compute tasks
      # Video acceleration (VA-API)
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

  # Load AMD GPU kernel modules
  boot.initrd.kernelModules = ["amdgpu"];

  # Enable the X11 windowing system
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Enable Hyprland (Wayland tiling window manager)
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
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

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber = {
      enable = true;
      extraConfig."51-device-defaults" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              {
                "device.name" = "alsa_card.pci-0000_00_1b.0";
              }
            ];
            actions = {
              update-props = {
                "device.profile" = "output:analog-stereo+input:analog-stereo";
              };
            };
          }
        ];
      };
    };
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };

  # Use Blueman for Bluetooth management (works consistently in both KDE and Hyprland)
  services.blueman.enable = true;

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
    extraGroups = ["networkmanager" "wheel" "render" "video"];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIqaM3HaYC/wBPTOKMaK1wS21xiUtGdL74Bc/6yw95I9 macbook-to-nixos"
    ];
  };

  programs.fish = {
    enable = true;
    useBabelfish = true;
  };

  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    htop
    nvtopPackages.amd
    protonvpn-gui
    _1password-cli
    tailscale-systray
    lutris
    alsa-utils
    pulseaudio
    # Audio control tools for troubleshooting Bluetooth
    pavucontrol # PulseAudio/PipeWire volume control (useful for switching profiles)
    helvum # PipeWire patchbay (graphical audio routing)
  ];

  # Enable 1Password desktop and SSH agent
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [userConfig.username];
  };

  # NixOS-specific nix configuration
  nix.settings = {
    auto-optimise-store = true;
    # Download performance tuning (optimized for ~1 Gbps connection)
    http-connections = 128; # Max parallel downloads for fast connection
    connect-timeout = 20; # Quick timeout for fast/reliable connection
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
    gamescopeSession.enable = true; # Better Wayland/gaming session support
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
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        # Use performance CPU governor when gaming
        renice = 10;
      };
      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode stopped'";
      };
    };
  };

  # CPU performance optimizations for gaming
  powerManagement.cpuFreqGovernor = "performance";

  # Enable USB devices to wake from suspend
  powerManagement.enable = true;
  services.upower.enable = true;

  # Disable USB autosuspend to allow keyboard/mouse wake
  boot.extraModprobeConfig = ''
    options usbcore autosuspend=-1
  '';

  # Improve scheduler for gaming (reduce latency)
  boot.kernel.sysctl = {
    "kernel.sched_autogroup_enabled" = 0; # Disable autogroup for better game performance
    "vm.swappiness" = 10; # Reduce swapping (you have plenty of RAM)
  };

  # Mount 1TB HDD at /mnt/storage
  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/c8f55f79-207e-4b8b-9a28-58806ea455cf";
    fsType = "ext4";
    options = ["defaults" "nofail"]; # nofail allows boot even if drive is disconnected
  };

  systemd.tmpfiles.rules = [
    # Create storage subdirectories on 1TB HDD
    "d /mnt/storage 0755 ${userConfig.username} users -"
    "d /mnt/storage/media 0755 ${userConfig.username} users -"
    "d /mnt/storage/media/Movies 0755 ${userConfig.username} users -"
    "d /mnt/storage/media/TV 0755 ${userConfig.username} users -"
    "d /mnt/storage/games 0755 ${userConfig.username} users -"
    "d /mnt/storage/torrents 0755 ${userConfig.username} users -"
    # Legacy /srv/media for compatibility (can remove later if not needed)
    "d /srv/media 0755 ${userConfig.username} users -"
    "d /srv/media/Movies 0755 ${userConfig.username} users -"
    "d /srv/media/TV 0755 ${userConfig.username} users -"
  ];

  services.qbittorrent = {
    enable = true;
    openFirewall = false;
    user = userConfig.username;
    group = "users";
  };

  # This is the initial NixOS release version from first install. Do not change.
  # See: https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "24.11";
}
