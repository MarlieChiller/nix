# User Configuration
# Modify this file locally with your actual values
# Use: git update-index --skip-worktree users.nix
# to prevent committing your personal changes
{
  gitName = "MarlieChiller";

  home = {
    username = "marliechiller";
    email = "marliechiller@proton.me";
  };

  work = {
    username = "charlie.miller";
    email = "charlie.miller@zego.com";
    sshSigningKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC52GkKOE90Y/6tEaHVcNW28M9VJJAQmM990B2rzoRHk";
    sshSigningKeyFile = ".ssh/id_ed25519_signing";
  };

  nixos = {
    username = "marliechiller";
    email = "marliechiller@proton.me";
  };
}
