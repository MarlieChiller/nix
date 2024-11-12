{
  inputs,
  pkgs,
  ...
}: {
  programs.helix = {
    enable = true;
    settings = {
      # theme = "nord";
      editor.cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
      };
    };
    languages.language = [
      {
        name = "nix";
        auto-format = true;
        formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
      }
    ];
  };
}
