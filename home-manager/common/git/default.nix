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
     commit.gpgsign = true;
     push.autoSetupRemote = true;
    rerere.enable = true;
    };
    userEmail = "${name}@protonmail.me";
    userName = name;
  };
}
