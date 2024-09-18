{ ... }:
{
  programs.nixvim.plugins.lsp = {
    enable = true;
    inlayHints = true;
    servers = {
      bashls.enable = true;
      dockerls.enable = true;
      helm-ls.enable = true;
      html.enable = true;
      lua-ls.enable = true;
      marksman.enable = true;
      nil-ls.enable = true;
      pyright.enable = true;
      rust-analyzer = {
        enable = true;
        installCargo = true;
        installRustc = true;
      };
      svelte.enable = true;
      ts-ls.enable = true;
      yamlls.enable = true;
    };
  };
}

