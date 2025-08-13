# User Configuration
# Modify this file locally with your actual values
# Use: git update-index --skip-worktree users.nix
# to prevent committing your personal changes

{
  gitName = "Your Name";
  
  home = {
    username = "your-home-username";
    email = "your-email@example.com";
  };
  
  work = {
    username = "your-work-username";
    email = "your-work-email@company.com";
  };
}