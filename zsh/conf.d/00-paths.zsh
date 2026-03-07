# PATH Configuration

export PATH=$HOME/bin:$HOME/.local/bin:$HOME/scripts:/usr/local/bin:$PATH
if [ -n "$BREW_HOME" ]; then
  export PATH="$BREW_HOME/bin:$PATH"
  export PATH="$BREW_HOME/opt/ruby/bin:$PATH"
  export PATH="$BREW_HOME/lib/ruby/gems/4.0.0/bin:$PATH"
  export PATH="$BREW_HOME/opt/python@3.12/libexec/bin:$PATH"
fi
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Unset GOROOT — Homebrew Go doesn't need it and a stale value breaks `go install`
unset GOROOT