# User Configuration Template
# Copy this file to users.nix and fill in your actual values
# users.nix will be ignored by git to keep your personal info private
{
  gitName = "Your Name";

  home = {
    username = "your-home-username";
    email = "your-email@example.com";
    # homeDirectory will be derived as "/Users/${username}"
  };

  work = {
    username = "your-work-username";
    email = "your-work-email@company.com";
    # homeDirectory will be derived as "/Users/${username}"
  };
}
