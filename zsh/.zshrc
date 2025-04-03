# PATH Configuration
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export PATH=$PATH:$HOME/go/bin
export PATH="$BREW_HOME/bin:$PATH"
export PATH="$BREW_HOME/opt/ruby/bin:$PATH"
export PATH="$BREW_HOME/lib/ruby/gems/3.4.0/bin:$PATH"
export PATH="$BREW_HOME/opt/ruby@3.3/bin:$PATH"
export PATH=$GOPATH/bin:$PATH
export PATH=$PATH:$(go env GOPATH)/bin

# Environment Variables
export ZSH="$HOME/.oh-my-zsh"
export GHOSTTY_HOME=$HOME/Library/Application\ Support/com.mitchellh.ghostty/config
export XDG_CONFIG_HOME="$HOME/.config"
export TERM="xterm-256color"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export GOPATH=$HOME/go
export STARSHIP_CONFIG=$HOME/.config/starship.toml
export NVM_DIR="$HOME/.nvm"

# Homebrew Configuration
if [ "$(uname)" = "Linux" ]; then
  BREW_HOME="/home/linuxbrew/.linuxbrew"
elif [ "$(uname)" = "Darwin" ]; then
  BREW_HOME="/opt/homebrew"
fi
eval "$($BREW_HOME/bin/brew shellenv)"

# Oh My Zsh
zstyle ':omz:update' mode auto
plugins=(git rbenv)
source $ZSH/oh-my-zsh.sh

# Editor Configuration
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi
alias vim=nvim
alias nvim-kickstart='NVIM_APPNAME="nvim-kickstart" nvim'

# Aliases
alias cd=z
alias ls="eza --no-filesize --grid --color=always --icons=always --no-user"
alias l="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"
alias ltree="eza --tree --level=2 --icons --git"
alias lg="lazygit"
alias sourcezsh="omz reload && exec zsh"

# NVM
[ -s "$BREW_HOME/opt/nvm/nvm.sh" ] && \. "$BREW_HOME/opt/nvm/nvm.sh"
[ -s "$BREW_HOME/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$BREW_HOME/opt/nvm/etc/bash_completion.d/nvm"

# Starship Prompt
eval "$(starship init zsh)"

# FZF Configuration
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

# TheFuck
eval $(thefuck --alias)
eval $(thefuck --alias fk)

# rbenv
eval "$(rbenv init -)"

# Mise
eval "$(mise activate zsh)"
eval "$(~/.local/bin/mise activate)"

# Zsh Plugins
source $BREW_HOME/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $BREW_HOME/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=cyan'
```

