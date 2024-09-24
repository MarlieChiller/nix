{
  lib,
  pkgs,
  ...
}: {
    programs.nixvim.plugins.conform-nvim = {
      enable = true;
      settings = {
        format_on_save = ''
          function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end

            if slow_format_filetypes[vim.bo[bufnr].filetype] then
              return
            end

            local function on_format(err)
              if err and err:match("timeout$") then
                slow_format_filetypes[vim.bo[bufnr].filetype] = true
              end
            end

            return { timeout_ms = 200, lsp_fallback = true }, on_format
           end
        '';

        format_after_save = ''
          function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end

            if not slow_format_filetypes[vim.bo[bufnr].filetype] then
              return
            end

            return { lsp_fallback = true }
          end
        '';
        notify_on_error = true;
        formatters_by_ft = {
          html = [
            [
              "prettierd"
              "prettier"
            ]
          ];
          css = [
            [
              "prettierd"
              "prettier"
            ]
          ];
          javascript = [
            [
              "prettierd"
              "prettier"
            ]
          ];
          typescript = [
            [
              "prettierd"
              "prettier"
            ]
          ];
          python = [
            "ruff"
          ];
          lua = ["stylua"];
          nix = ["alejandra"];
          markdown = [
            [
              "prettierd"
              "prettier"
            ]
          ];
          yaml = [
            [
              "prettierd"
              "prettier"
            ]
          ];
          terraform = ["terraform_fmt"];
          bicep = ["bicep"];
          bash = [
            "shellcheck"
            "shellharden"
            "shfmt"
          ];
          json = ["jq"];
          "_" = ["trim_whitespace"];
        };

        formatters = {
          ruff = {
            command = "${lib.getExe pkgs.ruff}";
          };
          alejandra = {
            command = "${lib.getExe pkgs.alejandra}";
          };
          jq = {
            command = "${lib.getExe pkgs.jq}";
          };
          prettierd = {
            command = "${lib.getExe pkgs.prettierd}";
          };
          stylua = {
            command = "${lib.getExe pkgs.stylua}";
          };
          shellcheck = {
            command = "${lib.getExe pkgs.shellcheck}";
          };
          shfmt = {
            command = "${lib.getExe pkgs.shfmt}";
          };
          shellharden = {
            command = "${lib.getExe pkgs.shellharden}";
          };
          bicep = {
            command = "${lib.getExe pkgs.bicep}";
          };
          #yamlfmt = {
          #  command = "${lib.getExe pkgs.yamlfmt}";
          #};
        };
      };
    };
  }

