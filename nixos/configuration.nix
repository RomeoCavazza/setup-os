{ config, lib, pkgs, ... }:

{
  imports = [
    # Hardware Scan
    ./hardware-configuration.nix

    # --- Modules: Core ---
    ./modules/nvidia-prime.nix
    ./modules/virtualisation.nix
    ./modules/emacs.nix
    ./modules/science-data.nix
    ./modules/launcher.nix
    ./modules/starship.nix

    # --- Modules: Services ---
    ./modules/databases.nix
    ./modules/ollama.nix
    ./modules/nginx.nix
    # ./modules/observability.nix
  ];

  # ============================================================================
  # BOOTLOADER (Systemd-boot)
  # ============================================================================
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.editor = false;
  boot.loader.systemd-boot.configurationLimit = 1;
  boot.loader.timeout = null;
  boot.loader.efi.canTouchEfiVariables = true;

  # Windows 11 Entry Override
  boot.loader.systemd-boot.extraEntries."windows.conf" = ''
    title Windows 11
    sort-key windows
    efi /EFI/Microsoft/Boot/bootmgfw.efi
  '';

  # Enforce loader configuration
  boot.loader.systemd-boot.extraInstallCommands = ''
    ${pkgs.coreutils}/bin/mkdir -p /boot/loader
    ${pkgs.coreutils}/bin/cat > /boot/loader/loader.conf <<'EOF'
timeout menu-force
editor no
auto-entries no
auto-firmware yes
EOF
    ${pkgs.coreutils}/bin/chmod 0644 /boot/loader/loader.conf || true
  '';

  # Kernel Parameters
  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "pcie_aspm=off"
  ];

  boot.blacklistedKernelModules = [
    "iTCO_wdt"
    "iTCO_vendor_support"
  ];

  # ============================================================================
  # NIX SETTINGS
  # ============================================================================
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    warn-dirty = false;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # ============================================================================
  # SYSTEM CORE (Locale, Network, User)
  # ============================================================================
  networking.hostName = "nixos";

  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;

  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "fr_FR.UTF-8";
  console.keyMap = "fr";

  users.users.tco = {
    isNormalUser = true;
    shell = pkgs.bash;
    extraGroups = [
      "wheel"           # Sudo
      "networkmanager"  # Networking
      "video"           # Graphics
      "docker"          # Containers
      "libvirtd"        # VMs
      "dialout"         # Serial/Arduino
    ];
  };

  # ============================================================================
  # DESKTOP ENVIRONMENT
  # ============================================================================
  services.xserver = {
    enable = true;
    xkb.layout = "fr";
  };

  # GDM & GNOME
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Integration & Portals
  services.gnome.gnome-keyring.enable = true;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  # ============================================================================
  # HARDWARE SUPPORT (Audio, BT, Graphics, Firmware)
  # ============================================================================
  hardware.enableRedistributableFirmware = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Graphics (OpenGL/Vulkan) - 32-bit needed for Steam/Proton
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # ============================================================================
  # SECURITY / POLKIT
  # ============================================================================
  security.polkit.enable = true;

  # Start a polkit agent in the user session
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
    };
  };

  # ============================================================================
  # SHUTDOWN / REBOOT RELIABILITY
  # ============================================================================
  services.logind.settings.Login.KillUserProcesses = true;

  systemd.settings.Manager = {
    DefaultTimeoutStopSec = "15s";
  };

  # ============================================================================
  # QUALITY OF LIFE & SYSTEM PACKAGES
  # ============================================================================
  programs.zoxide.enable = true;
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  services.logrotate.enable = true;

  # Handle Home Manager collisions during rebuilds
  home-manager.backupFileExtension = "bak";

  environment.systemPackages = with pkgs; [
    # Cursor themes available system-wide
    adwaita-icon-theme
    bibata-cursors

    vim neovim node2nix
    git wget curl
    iw ethtool pciutils usbutils
    tree ripgrep fd fzf
    fastfetch btop htop
    kitty foot
    firefox google-chrome
    wl-clipboard
    pavucontrol
    networkmanager
    polkit_gnome

    # Python + pip (Nix way)
    python3
    python3Packages.pip
    python3Packages.virtualenv
    pipx

    # IDE
    arduino-ide
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    EDITOR = "vim";
  };

  system.stateVersion = "24.05";
}
