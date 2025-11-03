{
  userConfig,
  ...
}: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    extraConfig = ''
      IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    '';
    matchBlocks = {
      "*" = {
        controlMaster = "auto";
        controlPersist = "30m";
        extraOptions = {preferredAuthentications = "publickey";};
        forwardAgent = false;
        hostname = "github.com";
        serverAliveInterval = 60;
        user = "git";
      };
    };
  };

  # Create allowed signers file for Git SSH commit signing
  home.file.".ssh/allowed_signers".text = "${userConfig.email} ${userConfig.sshSigningKey}";
}
