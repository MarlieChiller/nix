# Nix Darwin + Home Manager Configuration

Multi-host macOS configuration for personal and work environments.

## Quick Context

- **Platforms**: macOS (Apple Silicon) + NixOS (x86_64)
- **Machines**: `home-darwin`, `home-nixos`, `work-darwin`
- **Users**: marliechiller (home), charlie.miller (work)
- **Theming**: Stylix with Nord (home) / Rose Pine (work)
- **Font**: JetBrains Mono Nerd Font
- **Shell**: Fish + Zellij

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
│       └── configuration.nix    # NixOS desktop config
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

## Security Notes

- SSH keys managed by 1Password
- No hardcoded secrets in configuration
- Stylix handles theming consistently
