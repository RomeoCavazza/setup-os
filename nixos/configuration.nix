{ config, pkgs, ... }:

let
  # VSCode packagé avec extensions
  myVscode = pkgs.vscode-with-extensions.override {
    vscode = pkgs.vscode;
    vscodeExtensions = with pkgs.vscode-extensions; [
      ms-python.python
      ms-toolsai.jupyter
      redhat.java
      vscjava.vscode-java-pack
      ms-dotnettools.csharp
      golang.go
      rust-lang.rust-analyzer
      ms-vscode.cpptools
      esbenp.prettier-vscode
      bmewburn.vscode-intelephense-client
      xdebug.php-debug
      sumneko.lua
    ];
  };

  # Interpréteur Python global
  pythonEnv = pkgs.python311.withPackages (ps: with ps; [
    # --- Data Science & Maths ---
    jupyter
    notebook
    ipykernel
    numpy
    pandas
    matplotlib
    scipy

    # --- Web / API ---
    fastapi uvicorn gunicorn httpx pydantic python-dotenv
    # DB / ORM / migrations
    sqlalchemy alembic psycopg psycopg2
    # Auth / sécurité / rate limit
    passlib python-jose slowapi limits
    # Qualité
    ruff mypy types-requests types-python-dateutil
  ]);
in
{
  ############################
  ## 0) Imports
  ############################
  imports = [
    ./hardware-configuration.nix
    ./modules/databases.nix
    ./modules/tmpfiles.nix
    ./modules/ollama.nix
    ./modules/launcher.nix
    ./modules/starship.nix
  ];

  ############################
  ## 1) Nix & ménage
  ############################
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };

  services.journald.extraConfig = ''
    SystemMaxUse=200M
    RuntimeMaxUse=100M
    RateLimitInterval=0
    RateLimitBurst=0
  '';

  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      dates  = "weekly";
      flags  = [ "--all" "--volumes" ];
    };
  };

  ############################
  ## 2) Boot / Kernel / Firmware / Réseau
  ############################
  # Boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 1;
  boot.loader.timeout = null;
  boot.loader.systemd-boot.editor = false;

  # Désactivation watchdog
  boot.kernelParams = [
    "nowatchdog"
    "nmi_watchdog=0"
  ];

  # Firmware
  hardware.enableRedistributableFirmware = true;
  hardware.firmware = [ pkgs.linux-firmware ];

  # Blacklist watchdog matériel
  boot.blacklistedKernelModules = [
    "iTCO_wdt"
    "iTCO_vendor_support"
    "wdt"
  ];

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.hosts."127.0.0.1" = [ "dev.localhost" ];

  ############################
  ## 3) Locales / Console
  ############################
  time.timeZone = "Europe/Paris";

  i18n.defaultLocale = "fr_FR.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  console.keyMap = "fr";

  ############################
  ## 4) Utilisateur
  ############################
  users.users.tco = {
    isNormalUser = true;
    description  = "tco";
    extraGroups  = [ "networkmanager" "wheel" "video" "docker" ];
  };

  ############################
  ## 5) Desktop / Audio / Bluetooth
  ############################
  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "fr";
    variant = "";
  };

  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  services.displayManager.defaultSession = "gnome";
  services.xserver.desktopManager.gnome.enable = true;

  # Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Services Gnome / DBus / Keyring
  services.dbus.enable = true;
  security.polkit.enable = true;
  programs.dconf.enable = true;
  services.gnome.gnome-keyring.enable = true;

  # XDG Portals
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  services.printing.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  # Audio PipeWire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  ############################
  ## 6) GPU
  ############################
  services.xserver.videoDrivers = [ "modesetting" ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  ############################
  ## 7) Env Wayland
  ############################
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    
    # Variables curseur
    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE  = "24";
    JAVA_HOME     = "${pkgs.jdk21}/lib/openjdk";
  };

  ############################
  ## 8) Outils dev & logiciels
  ############################
  programs.firefox.enable = true;
  programs.nm-applet.enable = true;

  # --- Outils de Navigation Terminal ---
  # Zoxide (Navigation intelligente 'z')
  programs.zoxide.enable = true;
  
  # FZF (Recherche floue CTRL+T/CTRL+R)
  programs.fzf.keybindings = true;
  programs.fzf.fuzzyCompletion = true;

  # Alias
  programs.bash.shellAliases.cursor =
    "appimage-run ~/.local/bin/appimages/Cursor.AppImage";

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  environment.systemPackages = with pkgs; [
    # Base utils
    vim git git-lfs gh tree eza ripgrep fd bat jq fzf unzip zip wget curl just appimage-run
    brightnessctl usbutils pciutils lshw fastfetch btop htop nvtopPackages.intel atop bottom cmatrix

    # --- FileManager / Navigation TUI ---
    yazi zoxide broot ranger lf walk zsh-fzf-tab

    # UI / outils
    hyprland hyprpaper hypridle hyprlock waybar pywal wl-clipboard grim slurp grimblast swappy wdisplays
    kitty foot rofi-wayland polkit_gnome networkmanagerapplet mako cliphist home-manager
    imv mpv discord adwaita-icon-theme papirus-icon-theme starship glances
    xfce.thunar xfce.thunar-archive-plugin file-roller gvfs swaynotificationcenter

    # Audio
    pavucontrol helvum easyeffects bluez blueman

    # Fonts
    jetbrains-mono

    # Nix & DX
    direnv nix-direnv nixd alejandra starship

    # Toolchains
    gcc gnumake cmake pkg-config nginx
    llvmPackages_latest.clang
    llvmPackages_latest.llvm
    llvmPackages_latest.llvm.dev
    stdenv.cc.cc.lib
    nodejs_20
    pnpm

    # Python
    pythonEnv
    pipx
    poetry
    uv

    # DB & outils
    postgresql_17
    dbeaver-bin
    pgcli

    # IDEs
    jetbrains.idea-community
    myVscode

    # Divers
    ollama claude-code
    docker-compose
  ];

  environment.localBinInPath = true;

  ############################
  ## 9) Fonts
  ############################
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji
    jetbrains-mono
  ];

  ############################
  ## 13) État système
  ############################
  services.xe-guest-utilities.enable = false;
  system.stateVersion = "24.05";
}
