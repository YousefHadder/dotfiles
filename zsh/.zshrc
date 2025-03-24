# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

export GHOSTTY_HOME=$HOME/Library/Application\ Support/com.mitchellh.ghostty/config
export XDG_CONFIG_HOME="$HOME/.config"

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

if [ "$(uname)" = "Linux" ]; then
  BREW_HOME="/home/linuxbrew/.linuxbrew"
elif [ "$(uname)" = "Darwin" ]; then
  BREW_HOME="/opt/homebrew"
fi

eval "$($BREW_HOME/bin/brew shellenv)"

# ZSH_THEME="jonathan"
zstyle ':omz:update' mode auto      # update automatically without asking

plugins=(git rbenv)

source $ZSH/oh-my-zsh.sh

# User configuration

# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
 else
   export EDITOR='nvim'
 fi

alias vim=nvim
alias nvim-kickstart='NVIM_APPNAME="nvim-kickstart" nvim'
alias cd=z

export PATH=$PATH:$HOME/go/bin
export PATH="$BREW_HOME/bin:$PATH"
export PATH="$BREW_HOME/opt/ruby/bin:$PATH"
export PATH="$BREW_HOME/lib/ruby/gems/3.4.0/bin":$PATH
export PATH="$BREW_HOME/opt/ruby@3.3/bin:$PATH"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$BREW_HOME/opt/nvm/nvm.sh" ] && \. "$BREW_HOME/opt/nvm/nvm.sh"  # This loads nvm
[ -s "$BREW_HOME/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$BREW_HOME/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# Go Path
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH
export PATH=$PATH:$(go env GOPATH)/bin

# Starship 
eval "$(starship init zsh)"
# set Starship PATH
export STARSHIP_CONFIG=$HOME/.config/starship.toml

  
# NOTE: FZF
# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git "
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

export FZF_DEFAULT_OPTS="--height 50% --layout=default --border --color=hl:#2dd4bf"

# Setup fzf previews
export FZF_CTRL_T_OPTS="--preview 'bat --color=always -n --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --icons=always --tree --color=always {} | head -200'"

# fzf preview for tmux
export FZF_TMUX_OPTS=" -p90%,70% "  

# FZF with Git right in the shell by Junegunn : check out his github below
# Keymaps for this is available at https://github.com/junegunn/fzf-git.sh
source ~/scripts/fzf-git.sh

# Next level of an ls 
# options :  --no-filesize --no-time --no-permissions 
alias ls="eza --no-filesize --grid --color=always --icons=always --no-user" 
alias l="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"
alias ltree="eza --tree --level=2  --icons --git"

# LazyGit
alias lg="lazygit"

alias sourcezsh="omz reload && exec zsh"

# NOTE: ZOXIDE
eval "$(zoxide init zsh)"

eval $(thefuck --alias)
eval $(thefuck --alias fk)

eval "$(rbenv init -)"
eval "$(mise activate zsh)"

source $BREW_HOME/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $BREW_HOME/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
eval "$(~/.local/bin/mise activate)"
export PATH="$BREW_HOME/bin:$PATH"
eval "$(~/.local/bin/mise activate)"

