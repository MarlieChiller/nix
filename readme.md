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
