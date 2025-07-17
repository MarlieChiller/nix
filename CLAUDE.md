# Nix Darwin + Home Manager Configuration

Multi-host macOS configuration for personal and work environments.

## Quick Context

- **Platform**: macOS (Apple Silicon)
- **Users**: marliechiller (home), charliemiller (work)
- **Theming**: Stylix with Nord (home) / Rose Pine (work)
- **Font**: JetBrains Mono Nerd Font
- **Shell**: Fish + Zellij

## Build Commands

```bash
# Build and switch
darwin-rebuild switch --flake .

# Build only (test changes)
darwin-rebuild build --flake .

# Format code
alejandra .

# Check flake
nix flake check
```

## Structure

```
├── flake.nix                    # Main flake configuration
├── system/
│   ├── common/                  # Shared system config
│   ├── home/                    # Home-specific system config
│   └── work/                    # Work-specific system config
└── home-manager/
    ├── packages/                # Application configurations
    ├── hosts/                   # Host-specific user configs
    └── common/                  # Shared user configs
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