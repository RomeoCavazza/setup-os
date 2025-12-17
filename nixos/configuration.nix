{ config, pkgs, ... }:

let
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
      jnoortheen.nix-ide
    ];
  };

  pythonEnv = pkgs.python311.withPackages (ps: with ps; [
    jupyter notebook ipykernel numpy pandas matplotlib scipy
    fastapi uvicorn gunicorn httpx pydantic python-dotenv
    sqlalchemy alembic psycopg2
    passlib python-jose slowapi limits
    ruff mypy types-requests types-python-dateutil
  ]);
in
{
  imports = [ 
    ./hardware-configuration.nix
    ./modules/nvidia-prime.nix 
  ];

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;

    substituters = [
      "https://cache.nixos-cuda.org"
      "https://cuda-maintainers.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 1;
  boot.loader.systemd-boot.editor = false;
  boot.loader.timeout = 0;

  boot.kernelParams = [
    "nowatchdog"
    "nmi_watchdog=0"

    "nvidia-drm.modeset=1"
    "nvidia-drm.fbdev=0"

    "pcie_aspm=off"
    "intel_iommu=on"
    "iommu=pt"
  ];

  boot.blacklistedKernelModules = [
    "iTCO_wdt"
    "iTCO_vendor_support"
    "wdt"
    "nouveau"
  ];

  hardware.enableRedistributableFirmware = true;
  hardware.firmware = [ pkgs.linux-firmware ];

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.hosts."127.0.0.1" = [ "dev.localhost" ];

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

  users.users.tco = {
    isNormalUser = true;
    description = "tco";
    extraGroups = [ "networkmanager" "wheel" "video" "docker" ];
    shell = pkgs.bash;
  };

  # Desktop
  services.xserver.enable = true;
  services.xserver.xkb.layout = "fr";

  services.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  services.desktopManager.gnome.enable = true;
  services.displayManager.defaultSession = "gnome";

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.dbus.enable = true;
  security.polkit.enable = true;
  programs.dconf.enable = true;
  services.gnome.gnome-keyring.enable = true;

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

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # NVIDIA PRIME offload
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;

    # Patch Blackwell: tester l'open kernel module
    # (sur RTX 50xx, ça aide souvent)
    open = true;

    nvidiaSettings = true;
    nvidiaPersistenced = true;

    powerManagement.enable = true;
    powerManagement.finegrained = true;

    # Patch Blackwell: driver plus récent que "production"
    # (beta contient généralement les branches 57x/58x avant "production")
    package = config.boot.kernelPackages.nvidiaPackages.beta;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:2:0:0";
    };
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";

    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE = "24";

    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";

    CUDA_CACHE_PATH = "/home/tco/.nv/ComputeCache";
    JAVA_HOME = "${pkgs.jdk21}/lib/openjdk";
  };

  programs.firefox.enable = true;
  programs.nm-applet.enable = true;

  programs.zoxide.enable = true;

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.starship.enable = true;
  programs.nix-ld.enable = true;

  programs.bash.shellAliases = {
    cursor = "appimage-run ~/.local/bin/appimages/Cursor.AppImage";
  };

  programs.bash.interactiveShellInit = ''
    if [ -e ${pkgs.fzf}/share/fzf/key-bindings.bash ]; then
      source ${pkgs.fzf}/share/fzf/key-bindings.bash
    fi
    if [ -e ${pkgs.fzf}/share/fzf/completion.bash ]; then
      source ${pkgs.fzf}/share/fzf/completion.bash
    fi
  '';

  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
      flags = [ "--all" "--volumes" ];
    };
  };

  environment.localBinInPath = true;

  environment.systemPackages = with pkgs; [
    vim neovim
    git git-lfs gh
    wget curl
    tree eza
    ripgrep fd fzf
    bat jq just
    unzip zip
    appimage-run
    fastfetch
    btop htop atop bottom
    glances
    cmatrix

    pciutils usbutils lshw
    brightnessctl

    yazi broot ranger lf

    hyprland
    hyprpaper hypridle hyprlock
    waybar
    wl-clipboard
    grim slurp swappy
    wdisplays
    rofi
    cliphist
    imv mpv

    kitty
    foot
    swaynotificationcenter

    polkit_gnome
    networkmanagerapplet

    pavucontrol helvum easyeffects
    bluez blueman

    gcc gnumake cmake pkg-config
    nginx
    llvmPackages_latest.clang
    llvmPackages_latest.llvm
    llvmPackages_latest.llvm.dev
    stdenv.cc.cc.lib

    nodejs_20 pnpm

    pythonEnv
    pipx
    poetry
    uv

    postgresql_17
    dbeaver-bin
    pgcli

    # glxinfo
    mesa-demos

    myVscode
    jetbrains.idea-community

    discord
    docker-compose
    ollama
    nvtopPackages.nvidia
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    jetbrains-mono
  ];

  services.xe-guest-utilities.enable = false;
  system.stateVersion = "24.05";
}
