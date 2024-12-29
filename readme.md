- install darwin
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
