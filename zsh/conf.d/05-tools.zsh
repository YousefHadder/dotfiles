# Tool Initializations

# NVM (lazy-loaded to avoid ~500ms startup cost)
_nvm_lazy_load() {
  unset -f nvm node npm npx
  [ -s "$BREW_HOME/opt/nvm/nvm.sh" ] && \. "$BREW_HOME/opt/nvm/nvm.sh"
  [ -s "$BREW_HOME/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$BREW_HOME/opt/nvm/etc/bash_completion.d/nvm"
}
nvm() { _nvm_lazy_load; nvm "$@"; }
node() { _nvm_lazy_load; node "$@"; }
npm() { _nvm_lazy_load; npm "$@"; }
npx() { _nvm_lazy_load; npx "$@"; }

# Starship Prompt
eval "$(starship init zsh)"

# Zoxide
eval "$(zoxide init zsh)"

# pay-respects
eval "$(pay-respects zsh --alias)"

# rbenv — initialized in ~/.zprofile with --no-rehash (faster)