# Claude Code configuration
{
  config,
  pkgs,
  ...
}: let
  statuslineScript = pkgs.writeShellScript "claude-statusline" ''
    # Read JSON input from stdin
    input=$(cat)

    # Extract the current working directory
    cwd=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.workspace.current_dir')

    # Change to the directory for git commands
    cd "$cwd" 2>/dev/null || cd "$HOME"

    # ============ SHELL PROMPT SECTION ============
    # Get directory (abbreviated home path)
    dir=$(echo "$cwd" | sed "s|^$HOME|~|")

    # Get git branch and status
    git_info=""
    if ${pkgs.git}/bin/git rev-parse --git-dir > /dev/null 2>&1; then
        branch=$(${pkgs.git}/bin/git -c core.fileMode=false branch --show-current 2>/dev/null || ${pkgs.git}/bin/git rev-parse --short HEAD 2>/dev/null)
        if [ -n "$branch" ]; then
            # Check for dirty status
            if ! ${pkgs.git}/bin/git -c core.fileMode=false diff --quiet 2>/dev/null || ! ${pkgs.git}/bin/git -c core.fileMode=false diff --cached --quiet 2>/dev/null; then
                git_info=$(printf '\033[33m (%s*)\033[0m' "$branch")
            else
                git_info=$(printf '\033[32m (%s)\033[0m' "$branch")
            fi
        fi
    fi

    # Build shell prompt (cyan directory + git info)
    shell_prompt=$(printf '\033[36m%s\033[0m%s' "$dir" "$git_info")

    # ============ CLAUDE STATS SECTION ============
    claude_info=""

    # Extract Claude information from JSON
    model=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.model.display_name // "unknown"')
    output_style=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.output_style.name // ""')

    # Context window usage
    context_info=""
    usage=$(echo "$input" | ${pkgs.jq}/bin/jq '.context_window.current_usage')
    if [ "$usage" != "null" ]; then
        current_tokens=$(echo "$usage" | ${pkgs.jq}/bin/jq '.input_tokens + .cache_creation_input_tokens + .cache_read_input_tokens')
        context_size=$(echo "$input" | ${pkgs.jq}/bin/jq '.context_window.context_window_size')
        if [ "$current_tokens" != "null" ] && [ "$context_size" != "null" ] && [ "$context_size" -gt 0 ]; then
            context_pct=$((current_tokens * 100 / context_size))
            if [ "$context_pct" -gt 80 ]; then
                context_info=$(printf '\033[31m %d%%\033[0m' "$context_pct")
            elif [ "$context_pct" -gt 60 ]; then
                context_info=$(printf '\033[33m %d%%\033[0m' "$context_pct")
            else
                context_info=$(printf '\033[32m %d%%\033[0m' "$context_pct")
            fi
        fi
    fi

    # Total token usage across session
    total_input=$(echo "$input" | ${pkgs.jq}/bin/jq '.context_window.total_input_tokens // 0')
    total_output=$(echo "$input" | ${pkgs.jq}/bin/jq '.context_window.total_output_tokens // 0')
    if [ "$total_input" -gt 0 ] || [ "$total_output" -gt 0 ]; then
        total_k=$((($total_input + $total_output) / 1000))
        token_info=$(printf '\033[90m %dK tokens\033[0m' "$total_k")
    else
        token_info=""
    fi

    # Build Claude info section
    if [ "$model" != "unknown" ] && [ "$model" != "null" ]; then
        claude_info=$(printf ' \033[35m[%s' "$model")

        if [ -n "$context_info" ]; then
            claude_info="''${claude_info}''${context_info}"
        fi

        if [ -n "$token_info" ]; then
            claude_info="''${claude_info}''${token_info}"
        fi

        if [ -n "$output_style" ] && [ "$output_style" != "null" ] && [ "$output_style" != "default" ]; then
            claude_info="''${claude_info} $(printf '\033[36m%s\033[0m' "$output_style")"
        fi

        claude_info="''${claude_info}$(printf '\033[35m]\033[0m')"
    fi

    # Output combined prompt
    printf '%s%s' "$shell_prompt" "$claude_info"
  '';
in {
  # Claude settings.json
  home.file.".claude/settings.json".text = builtins.toJSON {
    statusLine = {
      type = "command";
      command = toString statuslineScript;
    };
    permissions = {
      allow = [
        # Search & exploration
        "Bash(rg:*)"
        "Bash(find:*)"
        "Bash(grep:*)"
        "Bash(cat:*)"
        "Bash(head:*)"
        "Bash(tail:*)"
        "Bash(ls:*)"
        "Bash(wc:*)"
        "Bash(which:*)"
        "Bash(type:*)"
        "Bash(file:*)"
        "Bash(mkdir:*)"
        # Git (read-only)
        "Bash(git status)"
        "Bash(git diff:*)"
        "Bash(git log:*)"
        "Bash(git branch:*)"
        "Bash(git show:*)"
        "Bash(git ls-files:*)"
        "Bash(git ls-tree:*)"
        # GitHub CLI
        "Bash(gh pr view:*)"
        "Bash(gh issue view:*)"
        "Bash(gh repo view:*)"
        # Web access
        "WebFetch(domain:github.com)"
        "WebFetch(domain:api.github.com)"
        "WebFetch(domain:gist.github.com)"
        "WebFetch(domain:docs.github.com)"
        "WebFetch(domain:npmjs.com)"
        "WebFetch(domain:pypi.org)"
        "WebFetch(domain:docs.anthropic.com)"
      ];
      deny = [
        "Bash(sudo:*)"
        "Bash(rm -rf:*)"
        "Read(.env)"
        "Read(.env.*)"
        "Read(**/*secret*)"
        "Read(**/*credential*)"
      ];
    };
  };
}
