# PATH Configuration

export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
if [ -n "$BREW_HOME" ]; then
  export PATH="$BREW_HOME/bin:$PATH"
  export PATH="$BREW_HOME/opt/ruby/bin:$PATH"
  export PATH="$BREW_HOME/lib/ruby/gems/3.4.0/bin:$PATH"
  export PATH="$BREW_HOME/opt/ruby@3.3/bin:$PATH"
fi
export GOPATH=$HOME/go
export GOROOT=$HOME/go-sdk/go
export PATH=$PATH:$GOPATH/bin:$GOROOT/bin