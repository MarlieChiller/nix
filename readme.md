- install darwin
- install neovim
  - `curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-macos-arm64.tar.gz
tar xzf nvim-macos-arm64.tar.gz
./nvim-macos-arm64/bin/nvim`
- install lazyvim
  - `git clone https://github.com/LazyVim/starter ~/.config/nvim`
  - edit lazyvim_plugin_setup.lua colour scheme
  - `cp -v ~/Projects/nix/system/common/lazyvim_plugin_setup.lua ~/.config/nvim/lua/plugins/`
  - `rm -rf ~/.config/nvim/.git`
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
