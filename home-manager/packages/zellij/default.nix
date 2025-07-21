{pkgs, ...}: {
  programs.zellij = {
    enable = true;
    settings = {
      default_shell = "${pkgs.fish}/bin/fish";
      copy_on_select = true;
      scrollback_editor = "${pkgs.neovim}/bin/nvim";
      keybinds = {
        normal = {
          "bind \"Ctrl t\"" = {
            SwitchToMode = "Tab";
          };
          "bind \"Alt h\"" = {
            MoveFocusOrTab = "Left";
          };
          "bind \"Alt l\"" = {
            MoveFocusOrTab = "Right";
          };
          "bind \"Alt Shift h\"" = {
            GoToPreviousTab = {};
          };
          "bind \"Alt Shift l\"" = {
            GoToNextTab = {};
          };
        };
        tab = {
          "bind \"h\"" = {
            GoToPreviousTab = {};
          };
          "bind \"l\"" = {
            GoToNextTab = {};
          };
          "bind \"Ctrl c\" \"Esc\"" = {
            SwitchToMode = "Normal";
          };
        };
      };
    };
  };
}
