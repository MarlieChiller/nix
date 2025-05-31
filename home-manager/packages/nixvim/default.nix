{
  # Import required modules
  inputs,
  ...
}: {
  imports = [inputs.nixvim.homeManagerModules.nixvim];

  programs.nixvim = {
    enable = true;

    # General Settings
    # copied from https://github.com/spector700/Akari/blob/main/config/settings.nix#L18
    globals = {
      mapleader = " "; # Set leader key to space
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
    };

    # Basic colorscheme
    colorschemes.rose-pine.enable = true;

    # Essential plugins
    plugins = {
      # File tree explorer
      nvim-tree = {
        enable = true;
        hijackNetrw = true;
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
          };
        };
      };

      web-devicons.enable = true;

      # Treesitter for better syntax highlighting
      treesitter = {
        enable = true;
        settings = {
          ensure_installed = [
            "python"
            "rust"
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
    ];
  };
}
