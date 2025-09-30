{userConfig, ...}: {
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = userConfig.gitName;
        email = userConfig.email;
      };
      ui = {
        editor = "nvim";
      };
    };
  };
}

