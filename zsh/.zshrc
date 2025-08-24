# Modular Zsh Configuration Loader
# This file sources all configuration files from conf.d/ directory

# Get the directory where this .zshrc file is located
ZSHRC_DIR="${${(%):-%x}:A:h}"

# Source all configuration files in order
for config_file in "$ZSHRC_DIR"/conf.d/*.zsh; do
    [ -r "$config_file" ] && source "$config_file"
done

unset config_file ZSHRC_DIR
