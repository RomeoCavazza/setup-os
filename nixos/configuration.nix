{ config, pkgs, ... }:

let
  myVscode = pkgs.vscode-with-extensions.override {
    vscode = pkgs.vscode;
    vscodeExtensions = with pkgs.vscode-extensions; [
      ms-python.python ms-toolsai.jupyter
      redhat.java vscjava.vscode-java-pack
      ms-dotnettools.csharp golang.go rust-lang.rust-analyzer
      ms-vscode.cpptools esbenp.prettier-vscode
      bmewburn.vscode-intelephense-client xdebug.php-debug sumneko.lua
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
  imports = [ ./hardware-configuration.nix ];

  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    substituters = [ "https://cache.nixos-cuda.org" "https://cuda-maintainers.cachix.org" ];
    trusted-public-keys = [ 
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };

  nix.gc = { automatic = true; dates = "daily"; options = "--delete-older-than 7d"; };
  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  boot.kernelParams = [ 
    "nowatchdog" "nmi_watchdog=0"
    "nvidia-drm.modeset=1" "nvidia-drm.fbdev=0"
    "pcie_aspm=off" "intel_iommu=on" "iommu=pt"
  ];
  
  boot.blacklistedKernelModules = [ "iTCO_wdt" "iTCO_vendor_support" "wdt" ];

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "fr_FR.UTF-8";
  console.keyMap = "fr";

  users.users.tco = {
    isNormalUser = true;
    description  = "tco";
    extraGroups  = [ "networkmanager" "wheel" "video" "docker" ];
    shell = pkgs.bash;
  };

  services.xserver.enable = true;
  services.xserver.xkb.layout = "fr";
  
  services.displayManager.gdm = { enable = true; wayland = true; };
  services.desktopManager.gnome.enable = true;
  programs.hyprland = { enable = true; xwayland.enable = true; };

  services.pipewire = { enable = true; alsa.enable = true; alsa.support32Bit = true; pulse.enable = true; };
  hardware.bluetooth.enable = true;
  services.dbus.enable = true;
  services.printing.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  
  hardware.graphics = { enable = true; enable32Bit = true; };
  
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
    
    prime = {
      offload = { enable = true; enableOffloadCmd = true; };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:2:0:0";
    };
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; MOZ_ENABLE_WAYLAND = "1";
    LIBVA_DRIVER_NAME = "nvidia"; GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    CUDA_CACHE_PATH = "/home/tco/.nv/ComputeCache";
  };

  programs.firefox.enable = true;
  programs.zoxide.enable = true;
  programs.direnv.enable = true;
  programs.nix-ld.enable = true;

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    vim neovim git git-lfs wget curl tree fastfetch btop htop nvtopPackages.nvidia
    ripgrep fd fzf unzip zip jq just appimage-run
    pciutils usbutils lshw brightnessctl
    
    kitty foot waybar swaynotificationcenter
    rofi 
    pavucontrol bluez blueman
    discord dbeaver-bin
    
    gcc gnumake cmake pkg-config
    nodejs_20 pnpm
    docker-compose
    
    pythonEnv
    myVscode
    jetbrains.idea-community
    
    ollama
    linuxPackages.nvidia_x11
  ];

  fonts.packages = with pkgs; [ jetbrains-mono noto-fonts noto-fonts-color-emoji ];

  system.stateVersion = "24.05";
}
