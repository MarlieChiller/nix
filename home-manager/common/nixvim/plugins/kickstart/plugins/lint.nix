{ pkgs, ...}:
{
  home.packages = with pkgs; [
    # formatters 
    alejandra
    hadolint
    eslint
    nodePackages.jsonlint
    markdownlint-cli
    ruff
    tflint
    vale
  ];

  programs.nixvim = {
    # Linting
    # https://nix-community.github.io/nixvim/plugins/lint/index.html
    plugins.lint = {
      enable = true;

      # NOTE: Enabling these will cause errors unless these tools are installed
      lintersByFt = {
        dockerfile = ["hadolint"];
        javascript = ["eslint"];
        json = ["jsonlint"];
        markdown = [ "markdownlint" ];
        nix = ["alejandra"];
        python = ["ruff"];
        terraform = ["tflint"];
        text = ["vale"];
      };

      # Create autocommand which carries out the actual linting
      # on the specified events.
      autoCmd = {
        callback.__raw = ''
          function()
            require('lint').try_lint()
          end
        '';
        group = "lint";
        event = [
          "BufEnter"
          "BufWritePost"
          "InsertLeave"
        ];
      };
    };

    # https://nix-community.github.io/nixvim/NeovimOptions/autoGroups/index.html
    autoGroups = {
      lint = {
        clear = true;
      };
    };
  };
}
