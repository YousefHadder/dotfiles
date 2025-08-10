# Homebrew Configuration

if [ "$(uname)" = "Linux" ]; then
  BREW_HOME="/home/linuxbrew/.linuxbrew"
elif [ "$(uname)" = "Darwin" ]; then
  BREW_HOME="/opt/homebrew"
fi
eval "$($BREW_HOME/bin/brew shellenv)"