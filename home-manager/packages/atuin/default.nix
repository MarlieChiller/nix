{
  config,
  pkgs,
  ...
}: {
  programs.atuin = {
    enable = true;
    settings = {
      auto_sync = true;
      sync_frequency = "5m";
      sync_address = "https://api.atuin.sh";
      filter_mode = "directory";
    };
  };
}
