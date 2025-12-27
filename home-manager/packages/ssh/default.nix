{
  userConfig,
  lib,
  pkgs,
  ...
}: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    extraConfig =
      if pkgs.stdenv.isDarwin
      then ''
        IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
      ''
      else ''
        IdentityAgent ~/.1password/agent.sock
      '';
    matchBlocks = {
      "home-desktop" = {
        hostname = "192.168.1.125"; # Local network IP
        user = "marliechiller";
        port = 22;
        identityFile = "~/.ssh/id_ed25519_nixos";
      };
      "home-desktop-remote" = {
        # Update this with your Tailscale hostname after setup
        # Example: hostname = "home-desktop.tailXXXX.ts.net";
        hostname = "TAILSCALE_HOSTNAME_HERE";
        user = "marliechiller";
        port = 22;
        identityFile = "~/.ssh/id_ed25519_nixos";
      };
      "github.com" = {
        user = "git";
      };
      "*" = {
        controlMaster = "auto";
        controlPersist = "30m";
        extraOptions = {preferredAuthentications = "publickey";};
        forwardAgent = false;
        serverAliveInterval = 60;
      };
    };
  };

  # Create allowed signers file for Git SSH commit signing (only if signing key exists)
  home.file = lib.optionalAttrs (userConfig ? sshSigningKey) {
    ".ssh/allowed_signers".text = "${userConfig.email} ${userConfig.sshSigningKey}";
  };
}
