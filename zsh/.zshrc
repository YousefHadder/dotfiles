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
export ANTHROPIC_BASE_URL=$(security find-generic-password -a "$USER" -s "ANTHROPIC_BASE_URL" -w)
export ANTHROPIC_AUTH_TOKEN=$(security find-generic-password -a "$USER" -s "ANTHROPIC_AUTH_TOKEN" -w)
export GITHUB_COPILOT_TOKEN=$(security find-generic-password -a "$USER" -s "GITHUB_COPILOT_TOKEN" -w)
export CATALOG_TOKEN=$(security find-generic-password -a "$USER" -s "CATALOG_TOKEN" -w)

