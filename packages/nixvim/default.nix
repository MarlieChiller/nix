{ inputs, ... }:
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./keymappings.nix
    ./lsp.nix
    ./noice.nix
    ./nvimtree.nix
    ./telescope.nix
    ./treesitter.nix
    ./yazi.nix
  ];
  programs.nixvim = {

    enable = true;

    # Theme
    colorschemes.onedark.enable = true;

    # Settings
    opts = {
      clipboard = "unnamedplus";
      cursorline = true;
      expandtab = true;
      ignorecase = true;
      mouse = "a";
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      smartcase = true;
      smartindent = true;
      tabstop = 2;
      termguicolors = true;
    };

    plugins = {
      lualine.enable = true;
      bufferline.enable = true;
      which-key.enable = true;
      nvim-autopairs.enable = true;
      rainbow-delimiters.enable = true;
    };
  };
}
