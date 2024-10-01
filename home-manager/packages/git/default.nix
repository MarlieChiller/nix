let
  name = "marliechiller";
in
{
  programs.git = {
    enable = true;
    extraConfig = {
      color.ui = true;
      core.editor = "nvim";
      credential.helper = "store";
      github.user = name;
      push.autoSetupRemote = true;
    };
    userEmail = "${name}@protonmail.me";
    userName = name;
  };
#  programs.ssh = {
#    enable = true;
#    addKeysToAgent = "yes";
#  };
}
