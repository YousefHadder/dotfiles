# Editor Configuration and Basic Aliases

export EDITOR='nvim'
alias n=nvim
alias nvim-kickstart='NVIM_APPNAME="nvim-kickstart" nvim'
alias lvim='NVIM_APPNAME="lvim" nvim'

# Navigation Aliases
alias cd=z

# File Listing Aliases
alias l="eza --icons=always"
alias ls="eza --icons=always"
alias ll="eza -lg --icons=always"
alias la="eza -lag --icons=always"
alias lt="eza -lTg --icons=always"
alias lt2="eza -lTg --level=2 --icons=always"
alias lt3="eza -lTg --level=3 --icons=always"
alias lt4="eza -lTg --level=4 --icons=always"
alias lta="eza -lTag --icons=always"
alias lta2="eza -lTag --level=2 --icons=always"
alias lta3="eza -lTag --level=3 --icons=always"
alias lta4="eza -lTag --level=4 --icons=always"

# Git Aliases
alias lg="lazygit"

# Reload Aliases
alias sourcezsh="omz reload && exec zsh"
alias sourcetmux="tmux source-file ~/.tmux.conf"

# Alias to start Claude Code → Copilot proxy
alias claude-proxy="~/.claude-copilot-proxy/start-proxy.sh"
alias claude-refresh="~/.claude-copilot-proxy/refresh-token.sh"
