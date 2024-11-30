let
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
      push.autoSetupRemote = true;
      rerere.enable = true;
    };
    userEmail = "${name}@protonmail.me";
    userName = name;
    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJvT8OYoGidygyDAhEC6M7XiDNFy5DZ1eSn256uAqHPa";
      signByDefault = true;
    };
  };
}
