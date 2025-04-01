# My Dotfiles

Welcome to my dotfiles repository! This collection contains my personalized configuration files and scripts that help me maintain a consistent development environment across different machines.

## Table of Contents

- [Overview](#overview)
- [Repository Structure](#repository-structure)
- [Installation](#installation)
- [Contributing](#contributing)

## Overview

In this repository, you'll find configuration files for various tools and applications, including:

- **Shell configurations:** Zsh
- **Editor configurations:** Neovim/Vim settings and plugins.
- **Git configuration:** Custom Git settings for version control.
- **Tool-specific configurations:** Settings for tools like tmux, starship, etc.

These dotfiles have evolved over time and are regularly updated to optimize my workflow and productivity.

## Repository Structure

The repository is organized into directories and files based on functionality:

- `zsh/`: Shell configuration files.
- `nvim/`: Neovim (or Vim) configurations, plugins, and custom scripts.
- `git/`: Git configuration files and aliases.
- `tmux/`: Tmux configuration.
- `starship/`: Starship command prompt config file
- `scripts/`: custom scripts for tmux, fzf-git, and others collected from openSource dotfiles on the hub
- `others/`: Additional configurations for other tools and applications.

Feel free to explore the structure and see how each piece fits together.

## Installation

You can quickly set up these dotfiles on your machine by following these steps:

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/yousefhadder/dotfiles.git ~/.dotfiles
   cd :~/.dotfiles
   ```
2. **Installation**
   
   First run the `setup.sh` script which will do all necessary updates based on the OS and switch to zsh.
   Then you need to quite the terminal to apply the shell change, and last you can run the `install.sh` to install other needed tools.
   
3. **Manual tweaks**
  
   This is still in the early stages of creation, you might come across some issues installing, and depending on your machine (macos, linux, ...)
  
   It is recommended to switch to zsh default shell before running the script, and then restarting the terminal for it to take effect.
   ```bash
   sudo chsh -s "$(which zsh)" "$USER"
   ```

## Contributing

  I've recently started using most of those CMD tools, and this repo is still in it's early stages, so any Contribution to improve it is appreaciated.
  Feel free to open a PR or an issue for me.
