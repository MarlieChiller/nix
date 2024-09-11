{ inputs, ... }:
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];
    programs.nixvim = {
      
    enable = true;

    # Theme
    colorschemes.nord.enable = true;

    # Settings
    opts = {
      expandtab = true;
      shiftwidth = 2;
      smartindent = true;
      tabstop = 2;
      number = true;
      relativenumber = true;
    };

    # Keymaps
    globals = {
      mapleader = " ";
    };

    plugins = {
      # UI
      lualine.enable = true;
      bufferline.enable = true;
      which-key = {
        enable = true;
      };

      noice = {
        enable = true;
        presets = {
          bottom_search = true;
          command_palette = true;
          long_message_to_split = true;
          #inc_rename = false;
          #lsp_doc_border = false;
        };
      };
      nvim-tree = {
        enable = true;
        autoReloadOnWrite = true;
      };
      yazi.enable = true;
      nvim-autopairs.enable = true;
      treesitter = {
        enable = true;
        nixGrammars = true;
        settings.indent.enable = true;
      };
      treesitter-context = {
        enable = true;
        settings = { max_lines = 2; };
      };
      rainbow-delimiters.enable = true;

     # Dev
      lsp = {
        enable = true;
        inlayHints = true;
        servers = {
          bashls.enable = true;
          dockerls.enable = true;
          helm-ls.enable = true;
          lua-ls.enable = true;
          marksman.enable = true;
          nil-ls.enable = true;
          pyright.enable = true;
          rust-analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
          tsserver.enable = true;
          yamlls.enable = true;
        };
      };
    };
  };
}
