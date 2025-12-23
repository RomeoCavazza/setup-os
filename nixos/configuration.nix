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
  boot.loader.systemd-boot.configurationLimit = 1; # Keep only current gen
  boot.loader.timeout = null; # Force menu display
  boot.loader.efi.canTouchEfiVariables = true;

  # Windows 11 Entry Override
  boot.loader.systemd-boot.extraEntries."windows.conf" = ''
    title Windows 11
    sort-key windows
    efi /EFI/Microsoft/Boot/bootmgfw.efi
  '';

  # Enforce loader configuration (Disable auto-windows, enable firmware UI)
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
  boot.kernelParams = [ "nvidia-drm.modeset=1" ];

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

  # GDM & GNOME (Wayland)
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Integration
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
  # HARDWARE SUPPORT (Audio, BT, Graphics)
  # ============================================================================
  # Audio (Pipewire)
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # ============================================================================
  # QUALITY OF LIFE & SYSTEM PACKAGES
  # ============================================================================
  programs.zoxide.enable = true;
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  services.logrotate.enable = true;

  # Handle Home Manager collisions
  home-manager.backupFileExtension = "bak";

  # Minimal System Packages (Core utilities only)
  environment.systemPackages = with pkgs; [
    vim neovim
    git wget curl
    tree ripgrep fd fzf
    fastfetch btop htop
    kitty foot
    firefox
    wl-clipboard
    pavucontrol
    networkmanager
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    EDITOR = "vim";
  };

  system.stateVersion = "24.05";
}
