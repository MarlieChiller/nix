- install nix (determinate with determinate flag disabled)
- install darwin
- install homebrew
- install neovim
  - follow binary install steps from here: https://github.com/neovim/neovim/releases
  - `sudo mkdir -p /usr/local/nvim`
  - `sudo mv nvim-macos-arm64/ /usr/local/nvim`
  - fish shell is already set to read path from previous step in home-manager but just in case, you added `set -U fish_user_paths /usr/local/nvim/bin $fish_user_paths` to it
./nvim-macos-arm64/bin/nvim`
- install lazyvim
  - `git clone https://github.com/LazyVim/starter ~/.config/nvim`
  - add `https://github.com/echasnovski/mini.base16` for stylix to theme properly
- add to karabiner: 

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
