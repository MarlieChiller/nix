# Nix Darwin + Home Manager Configuration

This is a personal macOS configuration managed with Nix Darwin and Home Manager. The setup supports multiple hosts (work and home) with shared and host-specific configurations.

## Repository Structure

```
.
├── flake.nix                    # Main flake configuration
├── system/                      # System-level configurations  
│   ├── common/configuration.nix # Shared system config (homebrew, defaults)
│   ├── work/configuration.nix   # Work-specific system config
│   └── home/configuration.nix   # Home-specific system config
└── home-manager/               # User-level configurations
    ├── hosts/                  # Host-specific home manager configs
    │   ├── work/default.nix    # Work host configuration
    │   └── home/default.nix    # Home host configuration
    ├── packages/               # Application configurations
    │   ├── default.nix         # Common packages and imports
    │   ├── fish/               # Fish shell configuration
    │   ├── kitty/              # Kitty terminal configuration
    │   ├── ghostty/            # Ghostty terminal configuration
    │   ├── wezterm/            # WezTerm terminal configuration
    │   ├── nixvim/             # Neovim configuration
    │   ├── helix/              # Helix editor configuration
    │   ├── git/                # Git configuration
    │   ├── starship/           # Starship prompt configuration
    │   ├── aerospace/          # Aerospace window manager
    │   ├── yazi/               # Yazi file manager
    │   ├── bat/                # Bat (cat replacement)
    │   └── ssh/                # SSH configuration
    └── assets/                 # Static assets (wallpapers, etc.)
        └── wallpapers/         # Wallpaper images
```

## Key Patterns & Conventions

### Multi-Host Setup
- **Users**: `marliechiller` (home), `charliemiller` (work)
- **Hosts**: `MacBook-Air` (home), `MOCULON03` (work)
- **Architecture**: Both use `aarch64-darwin` (Apple Silicon)

### Configuration Organization
- **System configs**: Located in `system/` directory, import common configuration
- **Home Manager**: Uses modular approach with `home-manager/packages/` for applications
- **Shared vs Host-specific**: Common configs in `packages/default.nix`, host-specific in `hosts/`

### Package Management Strategy
- **Nix packages**: Preferred for CLI tools and applications with good Home Manager support
- **Homebrew**: Used for GUI applications, casks, and tools without good Nix support
- **System packages**: Minimal, only essential system-level tools

### Styling & Theming
- **Stylix**: Used for consistent theming across applications
- **Themes**: Work uses `rose-pine`, home uses `nord`
- **Wallpapers**: Different wallpapers per host in `assets/wallpapers/`

## Important Configuration Details

### Package Structure
Each application in `home-manager/packages/` follows the pattern:
```nix
{pkgs, ...}: {
  home.packages = with pkgs; [ packageName ];  # If needed
  
  programs.appName = {
    enable = true;
    # application-specific configuration
  };
}
```

### Flake Inputs
- **nixpkgs**: Uses `nixpkgs-unstable` channel
- **nixvim**: For Neovim configuration
- **stylix**: For system theming
- **mac-app-util**: For macOS app integration
- **helix**: Direct from upstream for latest features

### Shell Configuration
- **Default shell**: Fish (configured in both system and home-manager)
- **Shell integration**: Kitty has fish integration enabled
- **Abbreviations**: Extensive fish abbreviations for common commands
- **Homebrew**: Sourced in fish shell init

### Development Environment
- **Editor**: Neovim via nixvim with extensive configuration
- **Terminal**: Multiple terminals configured (kitty, ghostty, wezterm)
- **Git**: Configured with fish integration
- **CLI tools**: Modern replacements (eza, fd, ripgrep, etc.)

## Common Operations

### Building & Switching
```bash
# Build and switch configuration
darwin-rebuild switch --flake .

# Build without switching
darwin-rebuild build --flake .

# Format nix files
alejandra .
```

### File Locations
- **Flake**: `/Users/[user]/Projects/nix/flake.nix`
- **System config**: `/Users/[user]/Projects/nix/system/[host]/configuration.nix`
- **Home config**: `/Users/[user]/Projects/nix/home-manager/hosts/[host]/default.nix`

### Key Abbreviations (Fish)
- `nconfig`: Navigate to nix configuration directory
- `ll*`: Various eza listing commands
- `gacam`: Git add, commit amend, force push

## Work-specific Configurations
- **Additional packages**: Google Cloud SDK, Terraform
- **Homebrew additions**: Postman, DataGrip, Docker, VS Code
- **Theme**: Rose Pine with leaves wallpaper

## Home-specific Configurations
- **Homebrew additions**: Discord, Steam, Signal, WhatsApp
- **Theme**: Nord with mountain wallpaper
- **Mac App Store**: NextDNS

## Development Notes
- **Stylix**: Automatically themes applications based on wallpaper/base16 scheme
- **Nix flakes**: Used for reproducible builds and dependency management
- **Home Manager**: Manages user-level configurations and dotfiles
- **macOS integration**: Uses mac-app-util for better app integration

## When making changes:
1. Follow the existing modular structure
2. Place application configs in `home-manager/packages/[app]/`
3. Add imports to `home-manager/packages/default.nix`
4. Use host-specific configs only when necessary
5. Test changes with `darwin-rebuild build --flake .` before switching
6. Format code with `alejandra .`