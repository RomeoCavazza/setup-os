{ config, pkgs, lib, ... }:

{
  # ============================================================================
  # USER IDENTITY & STATE
  # ============================================================================
  home.username = "tco";
  home.homeDirectory = "/home/tco";
  home.stateVersion = "25.05";

  # ============================================================================
  # DESKTOP SETTINGS (GNOME - Cursor)
  # ============================================================================
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      cursor-theme = "Adwaita";
      cursor-size = 24;
    };
  };

  # ============================================================================
  # PACKAGES (Grouped by Theme)
  # ============================================================================
  home.packages = with pkgs; [
    # --------------------------------------------------------------------------
    # Core CLI / Productivity
    # --------------------------------------------------------------------------
    bat
    eza
    fd
    fzf
    jq
    ripgrep
    yazi

    # --------------------------------------------------------------------------
    # Nix
    # --------------------------------------------------------------------------
    dockfmt
    nixfmt-rfc-style
    shellcheck
    home-manager
    shfmt

    # --------------------------------------------------------------------------
    # Editor / Code
    # --------------------------------------------------------------------------
    zed-editor
    neovim
    git
    lua-language-server
    lazygit
    aider-chat
    desktop-file-utils

    cargo
    openssl
    pkg-config
    rust-analyzer
    rustc
    rustfmt

    black
    isort

    typescript-language-server
    vscode-langservers-extracted
    tailwindcss-language-server

    nodejs_22
    pnpm
    yarn

    # --------------------------------------------------------------------------
    # Spelling / Dictionaries
    # --------------------------------------------------------------------------
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.fr

    # --------------------------------------------------------------------------
    # Fonts
    # --------------------------------------------------------------------------
    nerd-fonts.symbols-only

    # --------------------------------------------------------------------------
    # Monitoring / Observability (local)
    # --------------------------------------------------------------------------
    atop
    bottom
    btop
    glances
    htop
    nvtopPackages.full

    # --------------------------------------------------------------------------
    # Apps / Desktop
    # --------------------------------------------------------------------------
    appimage-run
    discord

    # --------------------------------------------------------------------------
    # Terminal toys
    # --------------------------------------------------------------------------
    cbonsai
    cmatrix
    hollywood
    pipes
    sl

    # --------------------------------------------------------------------------
    # CAD / Electronics
    # --------------------------------------------------------------------------
    freecad-wayland
    kicad
  ];

  # ============================================================================
  # VSCODE CONFIGURATION
  # ============================================================================
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        # Python / Jupyter
        ms-python.python
        ms-toolsai.jupyter

        # C/C++
        ms-vscode.cpptools

        # Rust
        rust-lang.rust-analyzer

        # Web / Formatting
        esbenp.prettier-vscode

        # Nix
        jnoortheen.nix-ide
        mkhl.direnv
      ];

      userSettings = {
        "editor.fontFamily" = "'JetBrainsMono Nerd Font', 'Droid Sans Mono', 'monospace'";
        "editor.fontLigatures" = true;
        "nix.enableLanguageServer" = true;
        "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font'";
        "window.titleBarStyle" = "custom";
      };
    };
  };

  # ============================================================================
  # GIT CONFIGURATION
  # ============================================================================
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "Romeo Cavazza";
        email = "ton.email@exemple.com"; # TODO: remplace par ton email réel
      };

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

    shellAliases = {
      g = "git";
      ll = "eza -l --icons";
      ls = "eza --icons";

      # Cursor (AppImage)
      cursor = "appimage-run ~/.local/bin/appimages/Cursor.AppImage --enable-features=UseOzonePlatform --ozone-platform=wayland";

      # Dev shells (flakes)
      devai = "nix develop /etc/nixos#ai";
      devemb = "nix develop /etc/nixos#embedded";

      # NixOS rebuild
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos";
    };
  };

  # ============================================================================
  # SYSTEM ACTIVATION SCRIPTS
  # ============================================================================
  home.activation.ensurePywalFootFile =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "$HOME/.cache/wal"
      if [ ! -f "$HOME/.cache/wal/colors-foot.ini" ]; then
        touch "$HOME/.cache/wal/colors-foot.ini"
      fi
    '';

  # ============================================================================
  # DESKTOP ENTRIES (Rofi / Waybar)
  # ============================================================================
  xdg.desktopEntries.cursor = {
    name = "Cursor";
    genericName = "AI Code Editor";
    comment = "Built for AI coding";
    exec = "appimage-run /home/tco/.local/bin/appimages/Cursor.AppImage --enable-features=UseOzonePlatform --ozone-platform=wayland";
    terminal = false;
    categories = [ "Development" "TextEditor" "IDE" ];
    icon = "/home/tco/.local/share/icons/cursor-icon.png";
  };
}
