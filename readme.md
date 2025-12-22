# Nix Darwin Configuration

Multi-host macOS configuration using Nix Darwin + Home Manager.

## Initial Setup

- Install nix determinate 
- Install darwin
- Install homebrew

## Personal Configuration

This repo uses a template-based approach for personal information:

1. **First time setup:** Modify `users.nix` with your actual values:
   ```nix
   {
     gitName = "Your Name";
     
     home = {
       username = "your-home-username";
       email = "your-email@example.com";
     };
     
     work = {
       username = "your-work-username";
       email = "your-work-email@company.com";
     };
   }
   ```

2. **Prevent committing personal data:**
   ```bash
   git update-index --skip-worktree users.nix
   ```

3. **Build configuration:**
   ```bash
   # For home machine
   sudo darwin-rebuild switch --flake .#home_machine
   
   # For work machine  
   sudo darwin-rebuild switch --flake .#work_machine
   ```

## Claude Code Statusline

A custom statusline for Claude Code that displays your Starship prompt plus Claude-specific information.

**Setup:**

1. Copy the statusline script to your Claude config:
   ```bash
   cp statusline-command.sh ~/.claude/statusline-command.sh
   chmod +x ~/.claude/statusline-command.sh
   ```

2. Update `~/.claude/settings.json`:
   ```json
   {
     "statusLine": {
       "type": "command",
       "command": "/Users/YOUR_USERNAME/.claude/statusline-command.sh"
     }
   }
   ```

**Features:**
- Displays your Starship prompt with full color support
- Shows Claude model name (cyan)
- Shows token usage (green <80%, yellow >80%)
- Shows active agent when running (magenta)
- Shows todo completion status when applicable (blue)

## Karabiner Configuration

- Add to karabiner:

```json
  {
    "manipulators": [
        {
            "description": "Change caps_lock to meh. (control+option+shift)",
            "from": {
                "key_code": "caps_lock",
                "modifiers": { "optional": ["any"] }
            },
            "to": [
                {
                    "key_code": "left_shift",
                    "modifiers": ["left_control", "left_option"]
                }
            ],
            "to_if_alone": [{ "key_code": "escape" }],
            "type": "basic"
        }
    ]
}
```
