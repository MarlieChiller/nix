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
    settings = {
      "home-desktop" = {
        Hostname = "192.168.1.125"; # Local network IP
        User = "marliechiller";
        Port = 22;
        IdentityFile = "~/.ssh/id_ed25519_nixos";
      };
      "home-desktop-remote" = {
        # Tailscale hostname (MagicDNS enabled)
        # Can also use IP directly: 100.103.154.90
        Hostname = "home-nixos";
        User = "marliechiller";
        Port = 22;
        IdentityFile = "~/.ssh/id_ed25519_nixos";
      };
      "github.com" = {
        User = "git";
      };
      "*" = {
        ControlMaster = "auto";
        # Without ControlPath, OpenSSH defaults it to "none" and multiplexing
        # never happens. %C hashes the connection tuple to stay under the
        # 104-char unix socket path limit.
        ControlPath = "~/.ssh/sockets/%C";
        ControlPersist = "30m";
        PreferredAuthentications = "publickey";
        ForwardAgent = false;
        ServerAliveInterval = 60;
      };
    };
  };

  home.file =
    {
      # ssh won't create the ControlPath parent directory itself
      ".ssh/sockets/.keep".text = "";
    }
    # Allowed signers file for Git SSH commit signing (only if signing key exists)
    // lib.optionalAttrs (userConfig ? sshSigningKey) {
      ".ssh/allowed_signers".text = "${userConfig.email} ${userConfig.sshSigningKey}";
    };
}
