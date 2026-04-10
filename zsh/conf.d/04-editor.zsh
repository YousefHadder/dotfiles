# Editor Configuration and Basic Aliases

# Zsh vi mode — h/j/k/l cursor movement on prompt
# bindkey -v
# bindkey -M viins 'jk' vi-cmd-mode
# export KEYTIMEOUT=15

export EDITOR='nvim'
alias n=nvim
alias nvim-kickstart='NVIM_APPNAME="nvim-kickstart" nvim'
alias lvim='NVIM_APPNAME="lvim" nvim'

# Search Aliases
alias find="fd"
alias grep="rg"

# Navigation Aliases
alias cd=z
alias tls="tmux ls"
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
alias gfp="git fetch && git pull"
alias gsm="git switch main && git fetch && git pull"
alias gpe="git push-empty"

# Reload Aliases
alias sourcezsh="omz reload && exec zsh"
alias sourcetmux="tmux source-file ~/.tmux.conf"

# Claude code/copilot cli
alias ccd="claude --dangerously-skip-permissions"
alias ccdr="claude --dangerously-skip-permissions --resume"
alias ccrt="~/.claude-copilot-proxy/refresh-token.sh"
alias cpa="copilot --yolo"
alias cpar="copilot --yolo --resume"

# alias pbcopy='printf "\033]52;c;$(base64 | tr -d "\n")\a"'

alias tn="zsh ~/scripts/tn"
alias cpenv="env | cut -d= -f1 | fzf --preview 'printenv {}' | xargs printenv | pbcopy"
