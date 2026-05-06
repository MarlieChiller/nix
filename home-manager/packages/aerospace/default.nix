{
  config,
  lib,
  pkgs,
  ...
}: {
  home.file.".aerospace.toml" = lib.mkIf pkgs.stdenv.isDarwin {
    text = builtins.replaceStrings ["@username@"] [config.home.username] (builtins.readFile ./aerospace.toml);
  };
}
