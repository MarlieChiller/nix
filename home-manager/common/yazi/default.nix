{
  pkgs,
  lib,
  ...
}: let
  yazi-plugins = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "b6597919540731691158831bf1ff36ed38c1964e";
    sha256 = "07dm70s48mas4d38zhnrfw9p3sgk83ki70xi1jb2d191ya7a2p3j";
  };
in {
  home.packages = with pkgs; [
    yazi
  ];
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    shellWrapperName = "yy";
    # theme = lib.importTOML ./tokyo-night.toml;

    settings = {
      manager = {
        show_hidden = true;
        ratio = [1 3 4];
      };
      preview = {
        max_width = 1000;
        max_height = 1000;
      };
    };

    plugins = {
      chmod = "${yazi-plugins}/chmod.yazi";
      full-border = "${yazi-plugins}/full-border.yazi";
      max-preview = "${yazi-plugins}/max-preview.yazi";
      starship = pkgs.fetchFromGitHub {
        owner = "Rolv-Apneseth";
        repo = "starship.yazi";
        rev = "20d5a4d4544124bade559b31d51ad41561dad92b";
        sha256 = "024nmc0ldkf9xzi6ymnk45d3ij2wismwfcd4p9025p5rdfsy4ynj";
      };
      smart-enter = ./plugins/smart-enter.yazi;
      smart-paste = ./plugins/smart-paste.yazi;
    };

    initLua = ''
      require("full-border"):setup()
      require("starship"):setup()
    '';

    keymap = {
      manager.prepend_keymap = [
        {
          on = "T";
          run = "plugin --sync max-preview";
          desc = "Maximize or restore the preview pane";
        }
        {
          on = ["c" "m"];
          run = "plugin chmod";
          desc = "Chmod on selected files";
        }
        {
          on = "l";
          run = "plugin --sync smart-enter";
          desc = "Enter the child directory, or open the file";
        }
        {
          on = "enter";
          run = "plugin --sync smart-enter";
          desc = "Enter the child directory, or open the file";
        }
        {
          on = "p";
          run = "plugin --sync smart-paste";
          desc = "Paste into the hovered directory or CWD";
        }
      ];
    };
  };
}
