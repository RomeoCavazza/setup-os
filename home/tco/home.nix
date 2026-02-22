{ config, pkgs, lib, ... }:

let
  # Helper: symlink depuis /etc/nixos (hors nix store)
  mkOut = config.lib.file.mkOutOfStoreSymlink;
in
{
  # ============================================================================
  # USER IDENTITY & STATE
  # ============================================================================
  home.username = "tco";
  home.homeDirectory = "/home/tco";
  home.stateVersion = "25.05";

  home.sessionPath = [ "$HOME/.local/bin" ];

  home.sessionVariables = {
    XDG_DATA_DIRS = "$HOME/.local/share:$XDG_DATA_DIRS";
  };

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
  # DOTFILES (Hyprland / Waybar / Rofi / Foot / Swappy)
  # Source of truth: /etc/nixos/nixos/config/*
  # ============================================================================
  xdg.enable = true;

  home.file.".config/hypr".source          = mkOut "/etc/nixos/nixos/config/hypr";
  home.file.".config/waybar".source        = mkOut "/etc/nixos/nixos/config/hypr/waybar";
  home.file.".config/rofi".source          = mkOut "/etc/nixos/nixos/config/rofi";
  home.file.".config/foot".source          = mkOut "/etc/nixos/nixos/config/foot";
  home.file.".config/swappy/config".source = mkOut "/etc/nixos/nixos/config/swappy/config";

  # Wrappers (scripts) : source of truth /etc/nixos/nixos/config/bin/*
  # NOTE: pas de executable=true ici -> le +x doit être sur le fichier source (/etc/...)
  home.file.".local/bin/cursor".source      = mkOut "/etc/nixos/nixos/config/bin/cursor";
  home.file.".local/bin/antigravity".source = mkOut "/etc/nixos/nixos/config/bin/antigravity";

  # ============================================================================
  # PACKAGES
  # ============================================================================
  home.packages = with pkgs; [
    # Core CLI / Productivity
    bat eza fd fzf jq ripgrep yazi home-manager

    # Nix tooling
    dockfmt nixfmt-rfc-style shellcheck shfmt

    # Editor / Code
    zed-editor neovim git lua-language-server lazygit aider-chat desktop-file-utils
    cargo openssl pkg-config rust-analyzer rustc rustfmt
    black isort
    typescript-language-server vscode-langservers-extracted tailwindcss-language-server
    nodejs_22 pnpm yarn

    # Spelling / Dictionaries
    aspell aspellDicts.en aspellDicts.en-computers aspellDicts.fr

    # UI
    papirus-icon-theme swaynotificationcenter cava nerd-fonts.symbols-only hyprcursor rose-pine-hyprcursor nerd-fonts.jetbrains-mono

    # Monitoring
    atop bottom btop glances htop

    # Apps / Desktop
    appimage-run discord

    # Terminal toys
    cbonsai cmatrix hollywood pipes sl

    # CAD / Electronics
    freecad-wayland kicad
  ];

  # ============================================================================
  # STARSHIP
  # ============================================================================
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
  };

  # ============================================================================
  # VSCODE
  # ============================================================================
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        ms-python.python
        ms-toolsai.jupyter
        ms-vscode.cpptools
        rust-lang.rust-analyzer
        esbenp.prettier-vscode
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
  # GIT
  # ============================================================================
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Romeo Cavazza";
        email = "romeo.cavazza@gmail.com";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  # ============================================================================
  # BASH
  # ============================================================================
  programs.bash = {
    enable = true;
    enableCompletion = true;

    # Foot lance souvent un shell non-login -> hm-session-vars pas sourcé.
    # On force un PATH propre ici.
    initExtra = ''
      if [ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
        . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
      fi
      export PATH="$HOME/.local/bin:$PATH"
    '';

    shellAliases = {
      g = "git";
      ll = "eza -l --icons";
      ls = "eza --icons";

      # Dev shells
      devai = "nix develop /etc/nixos/nixos#ai";
      devemb = "nix develop /etc/nixos/nixos#embedded";

      # Rebuild
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos/nixos#nixos";
    };
  };

  # ============================================================================
  # HOME ACTIVATION
  # ============================================================================
  home.activation.ensurePywalFootFile =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "$HOME/.cache/wal"
      if [ ! -f "$HOME/.cache/wal/colors-foot.ini" ]; then
        touch "$HOME/.cache/wal/colors-foot.ini"
      fi
    '';

  # ============================================================================
  # DESKTOP ENTRY (Cursor + Antigravity)
  # ============================================================================
  xdg.desktopEntries.cursor = {
    name = "Cursor";
    genericName = "AI Code Editor";
    comment = "Built for AI coding";
    exec = "cursor";
    terminal = false;
    categories = [ "Development" "TextEditor" "IDE" ];
    icon = "/home/tco/.local/share/icons/cursor-icon.png";
  };

  xdg.desktopEntries.antigravity = {
    name = "Antigravity";
    genericName = "IDE";
    comment = "Antigravity IDE";
    exec = "antigravity";
    terminal = false;
    categories = [ "Development" "IDE" ];
  };
}
