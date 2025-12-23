{ config, pkgs, lib, ... }:

{
  # ============================================================================
  # USER IDENTITY & STATE
  # ============================================================================
  home.username = "tco";
  home.homeDirectory = "/home/tco";
  home.stateVersion = "25.05";

  # ============================================================================
  # USER PACKAGES (CLI Tools & Utils)
  # ============================================================================
  home.packages = with pkgs; [
    # Modern CLI Replacements
    ripgrep     # grep replacement
    jq          # JSON processor
    yazi        # Terminal file manager
    bat         # cat replacement
    eza         # ls replacement
    fzf         # Fuzzy finder
    
    # Communication
    discord

    # --- EMACS DOOM TOOLS (Required for LSP/Linting) ---
    nixfmt-rfc-style  # Nix formatter
    shfmt             # Bash formatter
    shellcheck        # Bash linter
    dockfmt           # Dockerfile formatter
    
    # Python Basics (for Emacs support)
    black
    isort

    # Correction Orthographique (Pour Emacs/Flyspell)
    aspell
    aspellDicts.fr
    aspellDicts.en
    aspellDicts.en-computers # Vocabulaire technique
    
    # Fonts (Fixes Doom Emacs warnings)
    nerd-fonts.symbols-only
  ];

  # ============================================================================
  # VSCODE CONFIGURATION
  # ============================================================================
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    
    # Extensions (Declarative management)
    extensions = with pkgs.vscode-extensions; [
      ms-python.python
      ms-toolsai.jupyter
      ms-vscode.cpptools
      rust-lang.rust-analyzer
      esbenp.prettier-vscode
      jnoortheen.nix-ide
      mkhl.direnv
    ];

    # Settings (JSON)
    userSettings = {
      "editor.fontFamily" = "'JetBrainsMono Nerd Font', 'Droid Sans Mono', 'monospace'";
      "editor.fontLigatures" = true;
      "window.titleBarStyle" = "custom";
      "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font'";
      "nix.enableLanguageServer" = true;
    };
  };

  # ============================================================================
  # GIT CONFIGURATION
  # ============================================================================
  programs.git = {
    enable = true;
    userName = "Romeo Cavazza";
    userEmail = "ton.email@exemple.com"; # TODO: Update with real email
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  # ============================================================================
  # SHELL CONFIGURATION (Bash)
  # ============================================================================
  programs.bash = {
    enable = true;
    enableCompletion = true;

    # Aliases & Shortcuts
    shellAliases = {
      # Modern replacements
      ll = "eza -l --icons";
      ls = "eza --icons";
      g  = "git";
      
      # App Wrappers
      cursor = "appimage-run ~/.local/bin/appimages/Cursor.AppImage";
      
      # Nix Development Shortcuts
      devai = "nix develop /etc/nixos#ai";
      devemb = "nix develop /etc/nixos#embedded";
      
      # System Management
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
    };
  };
  
  # ============================================================================
  # SYSTEM ACTIVATION SCRIPTS
  # ============================================================================
  # Ensure Pywal cache directory exists to prevent Foot terminal errors
  home.activation.ensurePywalFootFile = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "$HOME/.cache/wal"
    if [ ! -f "$HOME/.cache/wal/colors-foot.ini" ]; then
      touch "$HOME/.cache/wal/colors-foot.ini"
    fi
  '';
}
