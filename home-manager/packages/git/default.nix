{
  pkgs,
  lib,
  userConfig,
  ...
}: {
  programs.git = {
    enable = true;
    settings = {
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
      user = {
        email = userConfig.email;
        name = userConfig.gitName;
      };
    };
    signing = {
      # SSH key managed by 1Password - no need to hardcode
      signByDefault = true;
    };
  };
}
