{
  pkgs,
  lib,
  userConfig,
  ...
}: {
  programs.git = {
    enable = true;
    settings =
      {
        user = {
          email = userConfig.email;
          name = userConfig.gitName;
        };
        color.ui = true;
        core.editor = "nvim";
        credential.helper = "store";
        github.user = userConfig.username;
        gitlab.user = userConfig.username;
        push.autoSetupRemote = true;
        rerere.enable = true;
      }
      // lib.optionalAttrs (userConfig ? sshSigningKey) {
        "gpg \"ssh\"" = {
          program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
          allowedSignersFile = "~/.ssh/allowed_signers";
        };
        gpg.format = "ssh";
      };
    signing = lib.mkIf (userConfig ? sshSigningKey) {
      # SSH key managed by 1Password
      signByDefault = true;
      key = userConfig.sshSigningKey;
    };
  };
}
