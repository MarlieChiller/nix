{
  config,
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
        "gpg \"ssh\"".allowedSignersFile = "~/.ssh/allowed_signers";
        gpg.format = "ssh";
      };
    signing = lib.mkIf (userConfig ? sshSigningKey) {
      signByDefault = true;
      key = "${config.home.homeDirectory}/${userConfig.sshSigningKeyFile}";
      format = "ssh";
    };
  };
}
