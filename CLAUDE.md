# Nix Darwin + Home Manager Configuration

Multi-platform configuration for macOS (Darwin) and Linux (NixOS) environments.

## Quick Context

- **Platforms**: macOS (Apple Silicon) + NixOS (x86_64)
- **Machines**: `home-darwin`, `home-nixos`, `work-darwin`
- **Users**: marliechiller (home), charlie.miller (work)
- **Theming**: Stylix with Nord (home) / Rose Pine (work)
- **Font**: JetBrains Mono Nerd Font
- **Shell**: Fish + Zellij

## Important: Claude Instructions

**NEVER run `darwin-rebuild` or `nixos-rebuild` commands.** The user will manually run these commands themselves after you make configuration changes.

## Build Commands

```bash
# Build and switch - Home Darwin
darwin-rebuild switch --flake .#home-darwin

# Build and switch - Work Darwin
darwin-rebuild switch --flake .#work-darwin

# Build and switch - Home NixOS (run on the NixOS machine)
sudo nixos-rebuild switch --flake .#home-nixos

# Build only (test changes before switching)
darwin-rebuild build --flake .#home-darwin
darwin-rebuild build --flake .#work-darwin
sudo nixos-rebuild build --flake .#home-nixos

# Format code
alejandra .

# Check flake
nix flake check
```

## Structure

```
├── flake.nix                    # Main flake configuration
├── system/
│   ├── common/                  # Shared config (darwin + nixos)
│   ├── darwin/
│   │   ├── common.nix           # Darwin-specific shared config
│   │   ├── home.nix             # Home machine config
│   │   └── work.nix             # Work machine config
│   └── nixos/
│       ├── configuration.nix    # NixOS desktop config
│       └── hardware-configuration.nix  # Machine-specific hardware config
└── home-manager/
    ├── packages/                # Shared application configs
    └── hosts/                   # Host-specific user configs
        ├── home/
        │   ├── darwin/          # Home macOS user config
        │   └── nixos/           # Home Linux user config
        └── work/
            └── darwin/          # Work macOS user config
```

## Key Applications

- **Terminal**: Kitty + Fish + Zellij
- **Editor**: Neovim (nixvim)
- **Git**: 1Password SSH signing
- **File Manager**: Yazi
- **Window Manager**: Aerospace

## NixOS Hardware Configuration

The `system/nixos/hardware-configuration.nix` file contains machine-specific hardware settings including:
- File system UUIDs and mount points
- Boot loader configuration
- Hardware detection (CPU, GPU, etc.)
- Kernel modules

**Important:**
- This file is committed for backup/reference purposes
- Contains machine-specific UUIDs and is NOT portable to other machines
- **If you reinstall NixOS**, regenerate this file:
  ```bash
  sudo nixos-generate-config --show-hardware-config > ~/Projects/nix/system/nixos/hardware-configuration.nix
  ```

## Security Notes

- SSH keys managed by 1Password
- No hardcoded secrets in configuration
- `hardware-configuration.nix` contains machine-specific UUIDs (not sensitive but specific to this machine)
- Stylix handles theming consistently
