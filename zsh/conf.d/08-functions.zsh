# Custom Functions

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

function lstree() {
    local depth=${1:-2}
    local dir=${2:-.}

    echo "📁 Contents of $(pwd)/$dir"
    echo "===================="
    ls -la "$dir"
    echo -e "\n🌳 Tree structure (depth $depth)"
    echo "===================="
    tree -L "$depth" "$dir"
}

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"