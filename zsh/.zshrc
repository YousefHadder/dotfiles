# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export GHOSTTY_HOME=$HOME/Library/Application\ Support/com.mitchellh.ghostty/config
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

if [ "$(uname)" = "Linux" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [ "$(uname)" = "Darwin" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Theme configuration
ZSH_THEME="jonathan"

# Auto-update configuration
zstyle ':omz:update' mode auto

# Plugins
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Aliases
alias sourcezsh="omz reload && exec zsh"
alias ls="eza --no-filesize --grid --color=always --icons=always --no-user"
alias l="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"
alias ltree="eza --tree --level=2  --icons --git"
alias lg="lazygit"

# Starship prompt
eval "$(starship init zsh)"
export STARSHIP_CONFIG=$HOME/.config/starship.toml

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# Go Path
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH
export PATH=$PATH:$(go env GOPATH)/bin

# FZF
eval "$(fzf --zsh)"
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
export FZF_DEFAULT_OPTS="--height 50% --layout=default --border --color=hl:#2dd4bf"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always -n --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --icons=always --tree --color=always {} | head -200'"
export FZF_TMUX_OPTS=" -p90%,70% "
source ~/scripts/fzf-git.sh

# Zoxide
eval "$(zoxide init zsh)"

# Rbenv
eval "$(rbenv init -)"

# Additional PATH configurations
export PATH=$PATH:$HOME/go/bin
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="/opt/homebrew/lib/ruby/gems/3.4.0/bin":$PATH
export PATH="/opt/homebrew/opt/ruby@3.3/bin:$PATH"

