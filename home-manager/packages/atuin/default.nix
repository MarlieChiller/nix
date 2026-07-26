{...}: {
  # Atuin's fish integration is sourced after fzf's and already wins Ctrl-R.
  # Make that explicit so home-manager stops warning about the clash.
  programs.fzf.historyWidget.fish.command = "";

  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      auto_sync = true;
      sync_frequency = "5m";
      sync_address = "https://api.atuin.sh";
      filter_mode = "directory";
    };
  };
}
