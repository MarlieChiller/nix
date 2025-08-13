{
  pkgs,
  lib,
  userConfig,
  ...
}: {
  programs.git = {
    enable = true;
    extraConfig = {
      color.ui = true;
      core.editor = "nvim";
      credential.helper = "store";
      github.user = userConfig.username;
      gitlab.user = userConfig.username;
      commit.sshsign = true;
      commit.gpgsign = false;
      "gpg \"ssh\"" = {
        program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      };
      push.autoSetupRemote = true;
      rerere.enable = true;
    };
    userEmail = userConfig.email;
    userName = userConfig.gitName;
    signing = {
      # SSH key managed by 1Password - no need to hardcode
      signByDefault = true;
    };
  };
}
