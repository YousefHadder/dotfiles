# Tool Initializations

# NVM
[ -s "$BREW_HOME/opt/nvm/nvm.sh" ] && \. "$BREW_HOME/opt/nvm/nvm.sh"
[ -s "$BREW_HOME/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$BREW_HOME/opt/nvm/etc/bash_completion.d/nvm"

# Starship Prompt
eval "$(starship init zsh)"

# Zoxide
eval "$(zoxide init zsh)"

# pay-respects
eval "$(pay-respects zsh --alias)"

# rbenv
eval "$(rbenv init -)"