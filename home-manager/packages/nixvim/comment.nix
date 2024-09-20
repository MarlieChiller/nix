{ ... }:
{
  programs.nixvim.plugins.comment = {
    enable = true;
    settings = {
      opleader.line = "<C-c>";
      toggler.line = "<C-c>";
    };
  };
}
