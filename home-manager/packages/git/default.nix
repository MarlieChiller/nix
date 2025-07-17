{
  pkgs,
  lib,
  ...
}: let
  name = "marliechiller";
in {
  programs.git = {
    enable = true;
    extraConfig = {
      color.ui = true;
      core.editor = "nvim";
      credential.helper = "store";
      github.user = name;
      gitlab.user = name;
      commit.sshsign = true;
      commit.gpgsign = false;
      "gpg \"ssh\"" = {
        program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      };
      push.autoSetupRemote = true;
      rerere.enable = true;
    };
    userEmail = "${name}@protonmail.me";
    userName = name;
    signing = {
      # SSH key managed by 1Password - no need to hardcode
      signByDefault = true;
    };
  };
}
