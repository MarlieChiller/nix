# Claude Configuration

This repository contains a comprehensive Nix Darwin + Home Manager configuration for macOS.

## For Claude Code Sessions

A detailed prompt about this repository structure and conventions is available in `.claude/prompt.md`. This prompt provides essential context about:

- Repository organization and patterns
- Multi-host setup (work/home configurations)
- Package management conventions
- Configuration patterns and best practices
- Common operations and workflows

## Quick Context

- **Platform**: macOS (Apple Silicon)
- **Users**: marliechiller (home), charliemiller (work)
- **Management**: Nix Darwin + Home Manager
- **Structure**: Modular configuration with shared and host-specific components

## Build Commands

```bash
# Build and switch
darwin-rebuild switch --flake .

# Build only
darwin-rebuild build --flake .

# Format
alejandra .
```

## Key Directories

- `system/` - System-level configurations
- `home-manager/packages/` - Application configurations
- `home-manager/hosts/` - Host-specific configurations
- `flake.nix` - Main flake configuration