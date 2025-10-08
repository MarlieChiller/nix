{
  # Import required modules
  inputs,
  ...
}: {
  imports = [inputs.nixvim.homeModules.nixvim];

  programs.nixvim = {
    enable = true;

    # General Settings
    # copied from https://github.com/spector700/Akari/blob/main/config/settings.nix#L18
    globals = {
      mapleader = " "; # Set leader key to space
      # Disable netrw to use yazi instead
      loaded_netrw = 1;
      loaded_netrwPlugin = 1;
    };

    opts = {
      cursorline = true; # Highlight the line where the cursor is located
      cmdheight = 2; # more space in the neovim command line for displaying messages

      # Enable relative line numbers
      number = true;
      relativenumber = true;

      # Tab spacing 2 spaces
      tabstop = 2;
      softtabstop = 2;
      shiftwidth = 2;
      expandtab = true;

      smartindent = true;
      wrap = false;

      # Smart indent on word wrap
      breakindent = true;

      # Undo stuff from days ago
      swapfile = false;
      backup = false;
      undofile = true;

      # Incremental search
      hlsearch = true;
      incsearch = true;

      # Better splitting
      splitbelow = true;
      splitright = true;

      # Enable ignorecase + smartcase for better searching
      ignorecase = true;
      smartcase = true; # Don't ignore case with capitals
      grepprg = "rg --vimgrep";
      grepformat = "%f:%l:%c:%m";

      # Better colors
      termguicolors = true;

      # Decrease updatetime
      updatetime = 50; # faster completion (4000ms default)

      # Enable the sign column to prevent the screen from jumping
      signcolumn = "yes";

      # Reduce which-key timeout to 250s
      timeoutlen = 250;

      scrolloff = 8; # Will never have less than 8 characters as you scroll down
      mouse = "a"; # Mouse

      # Set encoding type
      encoding = "utf-8";
      fileencoding = "utf-8";

      # Maximum number of items to show in the popup menu (0 means "use available screen space")
      pumheight = 0;

      colorcolumn = "80"; # Show column guide

      # Enable system clipboard
      clipboard = "unnamedplus";
    };

    # Colorscheme managed by Stylix

    # Essential plugins
    plugins = {
      # File tree explorer
      nvim-tree = {
        enable = true;
        settings = {
          hijack_netrw = true;
        };
      };

      # Fuzzy finder
      telescope = {
        enable = true;
        keymaps = {
          "<leader>ff" = "find_files";
          "<leader>fg" = "live_grep";
          "<leader>fb" = "buffers";
          "<leader>fh" = "help_tags";
        };
      };

      # Git integration
      gitsigns = {
        enable = true;
      };

      # Status line
      lualine = {
        enable = true;
      };

      # Auto-completion
      cmp = {
        enable = true;
      };

      # LSP support
      lsp = {
        enable = true;
        keymaps.lspBuf = {
          "gd" = "definition";
          "gD" = "declaration";
          "gr" = "references";
          "gi" = "implementation";
          "gt" = "type_definition";
          "K" = "hover";
          "<leader>rn" = "rename";
          "<leader>ca" = "code_action";
        };
        servers = {
          nil_ls = {
            enable = true;
            settings.formatting.command = ["alejandra"];
          };

          # Python LSP with Ruff
          ruff = {
            enable = true;
          };

          rust_analyzer = {
            # Rust LSP
            enable = true;
            installCargo = true;
            installRustc = true;
          };

          ts_ls = {
            enable = true;
            extraOptions = {
              preferences = {
                importModuleSpecifier = "relative";
                includeInlayParameterNameHints = "all";
                includeInlayPropertyDeclarationTypeHints = true;
                includeInlayFunctionLikeReturnTypeHints = true;
              };
            };
          };

          gopls = {
            enable = true;
          };
        };
      };

      # Enable format on save
      conform-nvim = {
        enable = true;
        settings = {
          format_on_save = {
            enable = true;
            timeoutMs = 3000;
          };
          formatters_by_ft = {
            nix = ["alejandra"];
            python = ["ruff_format"];
            go = ["gofmt"];
          };
        };
      };

      web-devicons.enable = true;

      # File manager integration
      yazi = {
        enable = true;
      };

      # Which-key for keybind hints
      which-key = {
        enable = true;
        settings = {
          delay = 200;
          expand = 1;
          notify = false;
          preset = "modern";
          replace = {
            desc = [
              ["<space>" "SPACE"]
              ["<leader>" "SPACE"]
              ["<[cC][rR]>" "RETURN"]
              ["<[tT][aA][bB]>" "TAB"]
              ["<[bB][sS]>" "BACKSPACE"]
            ];
          };
          spec = [
            {
              __unkeyed-1 = "<leader>f";
              group = "Find";
              icon = "🔍";
            }
            {
              __unkeyed-1 = "<leader>ff";
              desc = "Find Files";
              icon = "📁";
            }
            {
              __unkeyed-1 = "<leader>fg";
              desc = "Live Grep";
              icon = "🔤";
            }
            {
              __unkeyed-1 = "<leader>fb";
              desc = "Buffers";
              icon = "📋";
            }
            {
              __unkeyed-1 = "<leader>fh";
              desc = "Help Tags";
              icon = "❓";
            }
            {
              __unkeyed-1 = "<leader>e";
              desc = "Toggle File Tree";
              icon = "🌳";
            }
            {
              __unkeyed-1 = "<leader>y";
              desc = "File Manager";
              icon = "📂";
            }
            {
              __unkeyed-1 = "<leader>Y";
              desc = "File Manager (CWD)";
              icon = "📂";
            }
            {
              __unkeyed-1 = "<C-k>";
              desc = "Move To Window Up";
              icon = "⬆️";
            }
            {
              __unkeyed-1 = "<C-j>";
              desc = "Move To Window Down";
              icon = "⬇️";
            }
            {
              __unkeyed-1 = "<C-h>";
              desc = "Move To Window Left";
              icon = "⬅️";
            }
            {
              __unkeyed-1 = "<C-l>";
              desc = "Move To Window Right";
              icon = "➡️";
            }
            {
              __unkeyed-1 = "Y";
              desc = "Yank to system clipboard";
              icon = "📋";
            }
            {
              __unkeyed-1 = "<leader>b";
              group = "Buffer";
              icon = "📄";
            }
            {
              __unkeyed-1 = "<leader>bn";
              desc = "Next buffer";
              icon = "▶️";
            }
            {
              __unkeyed-1 = "<leader>bp";
              desc = "Previous buffer";
              icon = "◀️";
            }
            {
              __unkeyed-1 = "<leader>bd";
              desc = "Delete buffer";
              icon = "🗑️";
            }
            {
              __unkeyed-1 = "<leader>bD";
              desc = "Force delete buffer";
              icon = "💥";
            }
            {
              __unkeyed-1 = "<leader>bl";
              desc = "List buffers";
              icon = "📋";
            }
            {
              __unkeyed-1 = "<leader>ba";
              desc = "Open all buffers";
              icon = "📂";
            }
            {
              __unkeyed-1 = "<leader>bs";
              desc = "Save buffer";
              icon = "💾";
            }
            {
              __unkeyed-1 = "<leader>bS";
              desc = "Save all buffers";
              icon = "💾";
            }
            {
              __unkeyed-1 = "<leader>bq";
              desc = "Quit buffer";
              icon = "❌";
            }
            {
              __unkeyed-1 = "<leader>bQ";
              desc = "Quit all buffers";
              icon = "❌";
            }
          ];
        };
      };

      # Treesitter for better syntax highlighting
      treesitter = {
        enable = true;
        settings = {
          ensure_installed = [
            "python"
            "rust"
            "go"
            "nix"
            "lua"
            "javascript"
            "typescript"
            "tsx"
            "json"
            "html"
            "css"
          ];
        };
      };

      # Better treesitter text objects
      treesitter-textobjects = {
        enable = true;
        select = {
          enable = true;
          keymaps = {
            "af" = "@function.outer";
            "if" = "@function.inner";
            "ac" = "@class.outer";
            "ic" = "@class.inner";
            "aa" = "@parameter.outer";
            "ia" = "@parameter.inner";
          };
        };
      };

      # Commenting functionality
      comment = {
        enable = true;
        settings = {
          toggler = {
            line = "gcc";
            block = "gbc";
          };
          opleader = {
            line = "gc";
            block = "gb";
          };
        };
      };

      # Surround functionality
      nvim-surround.enable = true;

      # Indent guides
      indent-blankline = {
        enable = true;
        settings = {
          indent = {
            char = "│";
          };
          scope = {
            enabled = true;
            show_start = true;
            show_end = true;
          };
        };
      };

      # Better diagnostic viewer
      trouble = {
        enable = true;
        settings = {
          modes = {
            diagnostics = {
              auto_open = false;
              auto_close = true;
            };
          };
        };
      };

      # Buffer line (tab-like display)
      bufferline = {
        enable = true;
        settings = {
          options = {
            diagnostics = "nvim_lsp";
            show_buffer_close_icons = false;
            show_close_icon = false;
            separator_style = "thin";
          };
        };
      };

      # Rainbow brackets for better code readability
      rainbow-delimiters = {
        enable = true;
      };
    };

    # Key mappings
    keymaps = [
      {
        mode = "n";
        key = "<C-k>";
        action = "<C-w>k";
        options.desc = "Move To Window Up";
      }

      {
        mode = "n";
        key = "<C-j>";
        action = "<C-w>j";
        options.desc = "Move To Window Down";
      }

      {
        mode = "n";
        key = "<C-h>";
        action = "<C-w>h";
        options.desc = "Move To Window Left";
      }

      {
        mode = "n";
        key = "<C-l>";
        action = "<C-w>l";
        options.desc = "Move To Window Right";
      }

      # File manager keymaps
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>NvimTreeToggle<CR>";
        options.desc = "Toggle file tree";
      }
      {
        mode = "n";
        key = "<leader>y";
        action = "<cmd>Yazi<CR>";
        options.desc = "Open Yazi file manager";
      }
      {
        mode = "n";
        key = "<leader>Y";
        action = "<cmd>Yazi cwd<CR>";
        options.desc = "Open Yazi in current working directory";
      }

      # System clipboard keymaps
      {
        mode = "n";
        key = "Y";
        action = "\"+y$";
        options.desc = "Yank to end of line to system clipboard";
      }
      {
        mode = "v";
        key = "Y";
        action = "\"+y";
        options.desc = "Yank selection to system clipboard";
      }

      # Buffer management keymaps
      {
        mode = "n";
        key = "<leader>bn";
        action = "<cmd>bnext<CR>";
        options.desc = "Next buffer";
      }
      {
        mode = "n";
        key = "<leader>bp";
        action = "<cmd>bprevious<CR>";
        options.desc = "Previous buffer";
      }
      {
        mode = "n";
        key = "<leader>bd";
        action = "<cmd>bdelete<CR>";
        options.desc = "Delete buffer";
      }
      {
        mode = "n";
        key = "<leader>bD";
        action = "<cmd>bdelete!<CR>";
        options.desc = "Force delete buffer";
      }
      {
        mode = "n";
        key = "<leader>bl";
        action = "<cmd>ls<CR>";
        options.desc = "List buffers";
      }
      {
        mode = "n";
        key = "<leader>ba";
        action = "<cmd>ball<CR>";
        options.desc = "Open all buffers";
      }
      {
        mode = "n";
        key = "<leader>bs";
        action = "<cmd>w<CR>";
        options.desc = "Save buffer";
      }
      {
        mode = "n";
        key = "<leader>bS";
        action = "<cmd>wa<CR>";
        options.desc = "Save all buffers";
      }
      {
        mode = "n";
        key = "<leader>bq";
        action = "<cmd>q<CR>";
        options.desc = "Quit buffer";
      }
      {
        mode = "n";
        key = "<leader>bQ";
        action = "<cmd>qa<CR>";
        options.desc = "Quit all buffers";
      }
    ];

    # Auto-commands
    autoCmd = [];

    # Additional Lua configuration
    extraConfigLua = ''
      -- Configure rainbow-delimiters
      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = require('rainbow-delimiters.strategy.global'),
          vim = require('rainbow-delimiters.strategy.local'),
        },
        query = {
          [""] = 'rainbow-delimiters',
          lua = 'rainbow-blocks',
        },
        highlight = {
          'RainbowDelimiterRed',
          'RainbowDelimiterYellow',
          'RainbowDelimiterBlue',
          'RainbowDelimiterOrange',
          'RainbowDelimiterGreen',
          'RainbowDelimiterViolet',
          'RainbowDelimiterCyan',
        },
      }

      -- Rose Pine highlight overrides for better visibility
      vim.cmd([[
        highlight CursorLine guibg=#2a2837
        highlight Visual guibg=#403d52
      ]])

      -- Configure yazi.nvim for proper file opening
      require('yazi').setup({
        open_for_directories = false,
        open_multiple_tabs = false,
        floating_window_scaling_factor = 0.9,
        yazi_floating_window_winblend = 0,
        keymaps = {
          show_help = '<f1>',
          open_file_in_vertical_split = '<c-v>',
          open_file_in_horizontal_split = '<c-x>',
          open_file_in_tab = '<c-t>',
          grep_in_directory = '<c-s>',
          replace_in_directory = '<c-g>',
          cycle_open_buffers = '<tab>',
          copy_relative_path_to_selected_files = '<c-y>',
          send_to_quickfix_list = '<c-q>',
        },
        hooks = {
          yazi_closed_successfully = function(chosen_file, config, state)
            -- Only open the file if one was chosen
            if chosen_file then
              vim.cmd('edit ' .. chosen_file)
            end
          end,
        },
      })
    '';
  };
}
