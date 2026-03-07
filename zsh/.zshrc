# Modular Zsh Configuration Loader
# This file sources all configuration files from conf.d/ directory

# Get the directory where this .zshrc file is located
ZSHRC_DIR="${${(%):-%x}:A:h}"
SECRETS_FILE="$HOME/.secret-env-vars"

# Source secrets file if it exists
if [ -f $SECRETS_FILE ]; then
    source $SECRETS_FILE
fi

# Source all configuration files in order
for config_file in "$ZSHRC_DIR"/conf.d/*.zsh; do
    [ -r "$config_file" ] && source "$config_file"
done

unset config_file ZSHRC_DIR

# Claude Code -> GitHub Copilot Proxy
export SPLUNK_MCP_TOKEN=$(security find-generic-password -a "$USER" -s "SPLUNK_MCP_TOKEN" -w)
export AUTO_SYNC_TOKEN=$(security find-generic-password -a "$USER" -s "AUTO_SYNC_TOKEN" -w)
export CATALOG_TOKEN=$(security find-generic-password -a "$USER" -s "CATALOG_TOKEN" -w)
export DD_API_KEY=$(security find-generic-password -a "$USER" -s "DD_API_KEY" -w)
export DD_APP_KEY=$(security find-generic-password -a "$USER" -s "DD_APP_KEY" -w)
export ANTHROPIC_BASE_URL="http://localhost:4000"


export COPILOT_TOKEN=$(security find-generic-password -s "github-fr-tools-local-token" -w)

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh)"

# Claude Code -> GitHub Copilot Proxy
export ANTHROPIC_AUTH_TOKEN="fake-key"

# Claude Code -> GitHub Copilot Proxy
export CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS="1"

# bun completions
[ -s "/Users/yousefhadder/.bun/_bun" ] && source "/Users/yousefhadder/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
