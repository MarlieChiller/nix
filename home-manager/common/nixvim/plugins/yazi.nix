{
  programs.nixvim = {
    plugins.yazi = {
      enable = true;
      settings = {
      open_for_directories = true;};
    };
    keymaps = [
      {
        key = "\\";
        action = "<cmd>Yazi<cr>";
        options = {
          desc = "Yazi reveal";
        };
      }
    ];
  };
}
