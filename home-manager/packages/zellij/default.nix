{pkgs, ...}: {
  programs.zellij = {
    enable = true;
    settings = {
      default_shell = "${pkgs.fish}/bin/fish";
      copy_on_select = true;
      scrollback_editor = "${pkgs.neovim}/bin/nvim";
    };
  };
}