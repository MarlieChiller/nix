{
  lib,
  pkgs,
  ...
}: {
  home.file.".aerospace.toml" = lib.mkIf pkgs.stdenv.isDarwin {
    source = ./aerospace.toml;
  };
}
