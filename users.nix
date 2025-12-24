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
    sshSigningKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJvT8OYoGidygyDAhEC6M7XiDNFy5DZ1eSn256uAqHPa";
  };

  nixos = {
    username = "marliechiller";
    email = "marliechiller@proton.me";
  };
}
