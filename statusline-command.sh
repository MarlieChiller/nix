#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract the current working directory
cwd=$(echo "$input" | jq -r '.workspace.current_dir')

# Change to the directory and run starship
cd "$cwd" 2>/dev/null || cd "$HOME"

# Set required environment variables for starship
export STARSHIP_SHELL="fish"
export STARSHIP_SESSION_KEY="claude-code-$$"

# Run starship and strip only bash prompt escapes, keeping ANSI colors
starship_prompt=$(/nix/store/gv1kzwpcbg9ng3d4p2gnv9sia8ldsp0n-starship-1.24.1/bin/starship prompt 2>/dev/null | sed 's/\\[\[]//g; s/\\[\]]//g' | tr -d '\n')

# Extract Claude-specific information from JSON
model=$(echo "$input" | jq -r '.model.display_name // .model // "unknown"')
tokens_used=$(echo "$input" | jq -r '.tokens.used // 0')
tokens_total=$(echo "$input" | jq -r '.tokens.total // 0')
active_agent=$(echo "$input" | jq -r '.active_agent // ""')
todos_completed=$(echo "$input" | jq -r '.todos.completed // 0')
todos_total=$(echo "$input" | jq -r '.todos.total // 0')

# Build Claude info section with colors
claude_info=""

# Add model info (cyan)
if [ "$model" != "unknown" ] && [ "$model" != "null" ]; then
    claude_info="${claude_info}\033[36m ${model}\033[0m"
fi

# Add token usage (yellow if >80%, green otherwise)
if [ "$tokens_total" -gt 0 ]; then
    token_percent=$((tokens_used * 100 / tokens_total))
    if [ "$token_percent" -gt 80 ]; then
        claude_info="${claude_info} \033[33m${tokens_used}/${tokens_total}\033[0m"
    else
        claude_info="${claude_info} \033[32m${tokens_used}/${tokens_total}\033[0m"
    fi
fi

# Add active agent (magenta)
if [ -n "$active_agent" ] && [ "$active_agent" != "null" ]; then
    claude_info="${claude_info} \033[35m${active_agent}\033[0m"
fi

# Add todo status (blue)
if [ "$todos_total" -gt 0 ]; then
    claude_info="${claude_info} \033[34m${todos_completed}/${todos_total}\033[0m"
fi

# Output combined prompt
echo -ne "${starship_prompt}${claude_info}"
