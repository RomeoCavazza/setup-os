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

  # ============================================================================
  # PACKAGES
  # ============================================================================
  home.packages = with pkgs; [
    # Core CLI / Productivity
    bat eza fd fzf jq ripgrep yazi

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

    # Fonts
    nerd-fonts.symbols-only

    # Monitoring
    atop bottom btop glances htop
    # nvtopPackages.full

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

    shellAliases = {
      g = "git";
      ll = "eza -l --icons";
      ls = "eza --icons";

      # Cursor (AppImage)
      cursor = "appimage-run ~/.local/bin/appimages/Cursor.AppImage --enable-features=UseOzonePlatform --ozone-platform=wayland";

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
  # DESKTOP ENTRY (Cursor)
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
