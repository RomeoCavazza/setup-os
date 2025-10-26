{ config, pkgs, inputs, ... }:

let
  # VSCode packagé (sans Home-Manager)
  myVscode = pkgs.vscode-with-extensions.override {
    vscode = pkgs.vscode;
    vscodeExtensions = with pkgs.vscode-extensions; [
      ms-python.python redhat.java vscjava.vscode-java-pack
      ms-dotnettools.csharp golang.go rust-lang.rust-analyzer
      ms-vscode.cpptools esbenp.prettier-vscode
      bmewburn.vscode-intelephense-client xdebug.php-debug sumneko.lua
    ];
  };

  # Interpréteur Python global vu par Pyright/VSCode (toutes libs backend)
  pythonEnv = pkgs.python311.withPackages (ps: with ps; [
    # Web / API
    fastapi uvicorn gunicorn httpx pydantic python-dotenv
    # DB / ORM / migrations
    sqlalchemy alembic psycopg psycopg2
    # Auth / sécurité / rate limit
    passlib python-jose slowapi limits
    # Qualité (facultatif)
    ruff mypy types-requests types-python-dateutil
  ]);
in
{
  ############################
  ## 1) Nix & ménage
  ############################
  nixpkgs.config.allowUnfree = true;
  nix.settings = { experimental-features = [ "nix-command" "flakes" ]; auto-optimise-store = true; };
  nix.gc = { automatic = true; dates = "daily"; options = "--delete-older-than 7d"; };
  services.journald.extraConfig = ''
    SystemMaxUse=200M
    RuntimeMaxUse=100M
  '';

  virtualisation.docker = {
    enable = true;
    autoPrune = { enable = true; dates = "weekly"; flags = [ "--all" "--volumes" ]; };
  };

  ############################
  ## 2) Boot / Réseau
  ############################
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 1;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  services.resolved.enable = true;
  services.resolved.fallbackDns = [ "1.1.1.1" "8.8.8.8" "9.9.9.9" ];
  networking.nameservers = [ "127.0.0.53" ];
  networking.hosts."127.0.0.1" = [ "dev.localhost" ];

  ############################
  ## 3) Locales / Console
  ############################
  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "fr_FR.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS="fr_FR.UTF-8"; LC_IDENTIFICATION="fr_FR.UTF-8"; LC_MEASUREMENT="fr_FR.UTF-8";
    LC_MONETARY="fr_FR.UTF-8"; LC_NAME="fr_FR.UTF-8"; LC_NUMERIC="fr_FR.UTF-8";
    LC_PAPER="fr_FR.UTF-8"; LC_TELEPHONE="fr_FR.UTF-8"; LC_TIME="fr_FR.UTF-8";
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
  services.xserver.xkb = { layout = "fr"; variant = ""; };
  services.xserver.displayManager.gdm = { enable = true; wayland = true; };
  services.displayManager.defaultSession = "gnome";
  services.xserver.desktopManager.gnome.enable = true;

  programs.hyprland = { enable = true; xwayland.enable = true; };
  services.dbus.enable = true; security.polkit.enable = true; programs.dconf.enable = true;
  services.gnome.gnome-keyring.enable = true;

  xdg.portal = {
    enable = true; xdgOpenUsePortal = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland xdg-desktop-portal-gtk ];
  };

  services.printing.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  # Audio PipeWire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = { enable = true; alsa.enable = true; alsa.support32Bit = true; pulse.enable = true; };

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  ############################
  ## 6) GPU
  ############################
  services.xserver.videoDrivers = [ "modesetting" ];
  hardware.graphics = { enable = true; enable32Bit = true; };

  ############################
  ## 7) Env Wayland
  ############################
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland"; QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };

  ############################
  ## 8) Outils dev & logiciels
  ############################
  programs.firefox.enable = true;
  programs.bash.shellAliases.cursor = "appimage-run ~/.local/bin/appimages/Cursor.AppImage";

  environment.variables.JAVA_HOME = "${pkgs.jdk21}/lib/openjdk";

  programs.direnv.enable = true;               # direnv actif
  programs.direnv.nix-direnv.enable = true;    # intégration nix-direnv

  environment.systemPackages = with pkgs; [
    # Base utils
    vim git git-lfs gh tree eza ripgrep fd bat jq fzf zoxide unzip zip wget curl just appimage-run
    brightnessctl usbutils pciutils lshw fastfetch btop htop nvtopPackages.intel atop bottom cmatrix

    # UI / outils
    hyprland hyprpaper hypridle hyprlock waybar wl-clipboard grim slurp grimblast swappy wdisplays
    kitty foot rofi-wayland polkit_gnome networkmanagerapplet mako cliphist
    imv mpv discord papirus-icon-theme
    xfce.thunar xfce.thunar-archive-plugin file-roller gvfs

    # Audio
    pavucontrol helvum easyeffects bluez blueman

    # Fonts
    jetbrains-mono

    # Nix & DX
    direnv nix-direnv nixd alejandra starship

    # Toolchains
    gcc gnumake cmake pkg-config nginx
    llvmPackages_latest.clang llvmPackages_latest.llvm llvmPackages_latest.llvm.dev
    stdenv.cc.cc.lib nodejs_20 pnpm

    # Python (un seul interpréteur global avec toutes les libs)
    pythonEnv
    pipx poetry uv

    # DB & outils
    postgresql_17            # client 17
    dbeaver-bin pgcli

    # IDEs
    jetbrains.idea-community
    myVscode

    # Divers
    ollama docker-compose
  ];

  environment.localBinInPath = true;

  ############################
  ## 9) Fonts
  ############################
  fonts.packages = with pkgs; [
    noto-fonts noto-fonts-cjk-sans noto-fonts-cjk-serif noto-fonts-emoji jetbrains-mono
  ];

  ############################
  ## 10) PostgreSQL 17.6 (local)
  ############################
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_17;           # 17.x (17.6 sur canal stable)
    dataDir = "/var/lib/postgresql/17";
    # Extensions : PostGIS 17 si besoin
    extensions = [ pkgs.postgis ];
    authentication = pkgs.lib.mkOverride 10 ''
      # type  database  user      method
      local   all      postgres  peer
      local   all      all       md5
      host    all      all       127.0.0.1/32   md5
      host    all      all       ::1/128        md5
    '';
  };

  ############################
  ## 11) Redis (local)
  ############################
  services.redis.servers.insider = {
    enable = true;
    port = 6379;
    bind = "127.0.0.1";
    settings = {
      "appendonly" = "yes";                 # AOF
      "save" = [ "900 1" "300 10" "60 10000" ];
      "maxmemory" = "2gb";
      "maxmemory-policy" = "allkeys-lru";
      "loglevel" = "notice";
      "protected-mode" = "yes";
      "tcp-keepalive" = "60";
      "notify-keyspace-events" = "Ex";
    };
  };




  ############################
  ## 12) Imports
  ############################
  imports = [ ./hardware-configuration.nix ];

  ############################
  ## 13) État système
  ############################
  system.stateVersion = "25.05";
}
