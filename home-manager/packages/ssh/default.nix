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
      "nixos-home" = {
        hostname = "NIXOS_IP_HERE";  # Replace with your NixOS machine's IP or hostname
        user = "marliechiller";
        port = 22;
        identityFile = "~/.ssh/id_ed25519_nixos";
      };
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
