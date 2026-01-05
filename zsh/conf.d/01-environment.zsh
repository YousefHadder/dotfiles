# Environment Variables

export ZSH="$HOME/.oh-my-zsh"
export GHOSTTY_HOME=$HOME/Library/Application\ Support/com.mitchellh.ghostty/config
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export STARSHIP_CONFIG=$HOME/.config/starship.toml
export NVM_DIR="$HOME/.nvm"
export EZA_CONFIG_DIR="$XDG_CONFIG_HOME/eza"

# Claude Code → GitHub Copilot Proxy Configuration
export ANTHROPIC_BASE_URL="http://localhost:4000"
# Set a secure master key (generate with: openssl rand -hex 16)
export LITELLM_MASTER_KEY="${LITELLM_MASTER_KEY:-sk-claude-copilot-proxy-default}"
export ANTHROPIC_AUTH_TOKEN="${LITELLM_MASTER_KEY}"
# Note: Only set AUTH_TOKEN, not API_KEY, to avoid auth conflict

