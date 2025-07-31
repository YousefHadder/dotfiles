{ config, pkgs, system ? "x86_64-linux", ... }:

{
  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the paths it should manage
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "24.05";

  # Install packages from your Brewfile
  home.packages = with pkgs; [
    # Development tools
    nodejs
    nodePackages.npm
    lua
    luajit
    luarocks
    prettier
    gnumake
    tree-sitter

    # Shell enhancements
    zsh-autosuggestions
    zsh-syntax-highlighting
    fzf
    bat
    eza
    fd
    thefuck
    zoxide
    starship

    # File management and utilities
    yq
    yazi
    ripgrep
    tree
    stow

    # Git and development
    lazygit
    
    # Terminal multiplexer
    tmux
    
    # Editor
    neovim
  ];

  # Configure programs with Home Manager modules
  programs = {
    # Zsh configuration
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
      };
      
      shellAliases = {
        ll = "eza -la";
        la = "eza -la";
        ls = "eza";
        cat = "bat";
        cd = "z";
      };
      
      initExtra = ''
        # Initialize zoxide
        eval "$(zoxide init zsh)"
        
        # Initialize thefuck
        eval $(thefuck --alias)
        
        # FZF configuration
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
      '';
    };

    # Starship prompt
    starship = {
      enable = true;
      enableZshIntegration = true;
    };

    # FZF fuzzy finder
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    # Zoxide directory jumper
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    # Git configuration (if you want to manage it with Nix)
    git = {
      enable = true;
      # Add your git config here if desired
    };

    # Tmux
    tmux = {
      enable = true;
      # Add your tmux configuration here if desired
    };

    # Neovim
    neovim = {
      enable = true;
      # Add basic neovim configuration here if desired
    };

    # Bat (better cat)
    bat = {
      enable = true;
      config = {
        theme = "TwoDark";
        style = "numbers,changes,header";
      };
    };
  };

  # Manage dotfiles by symlinking them
  home.file = {
    # Neovim configuration
    ".config/nvim" = {
      source = ./nvim/.config/nvim;
      recursive = true;
    };
    
    # Tmux configuration
    ".tmux.conf" = {
      source = ./tmux/.tmux.conf;
    };
    
    # Yazi configuration
    ".config/yazi" = {
      source = ./yazi/.config/yazi;
      recursive = true;
    };
    
    # Scripts directory
    "scripts" = {
      source = ./scripts;
      recursive = true;
    };
    
    # Starship configuration
    ".config/starship.toml" = {
      source = ./starship/.config/starship.toml;
    };
  };

  # Environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "open";
  };

  # XDG directories
  xdg.enable = true;
}