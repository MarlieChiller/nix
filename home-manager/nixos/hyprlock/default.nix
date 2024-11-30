{
  inputs,
  pkgs,
  ...
}: {
  programs.hyprlock = {
    enable = true;

    package = inputs.hyprlock.packages.${pkgs.system}.hyprlock;

    settings = {
      general = {
        no_fade_in = false;
        grace = 0;
        disable_loading_bar = true;
      };
      label = [
        # TIME
        {
          text = "cmd[update:1000] echo \"$(date +\"%-I:%M%p\")\"";
          # color = "#cdd6f4";
          color = "rgba(255, 255, 255, 0.6)";
          font_size = 120;
          font_family = "JetBrains Mono Nerd Font Mono ExtraBold";
          position = "0, -300";
          halign = "center";
          valign = "top";
        }

        # USER
        {
          text = "cmd[update:1000] echo \"Hi there, $USER\"";
          # color = "#cdd6f4";
          color = "rgba(255, 255, 255, 0.6)";
          font_size = 25;
          font_family = "JetBrains Mono Nerd Font Mono";
          position = "0, -40";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
