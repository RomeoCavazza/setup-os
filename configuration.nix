{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ./modules/nvidia-prime.nix
    ./modules/virtualisation.nix
    ./modules/emacs.nix
    ./modules/science-data.nix
    ./modules/launcher.nix
    ./modules/starship.nix

    ./modules/databases.nix
    ./modules/ollama.nix
    ./modules/nginx.nix
    # ./modules/observability.nix
  ];

  # ============================================================================
  # BOOTLOADER
  # ============================================================================
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.editor = false;
  boot.loader.systemd-boot.configurationLimit = 1;
  boot.loader.timeout = null;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.systemd-boot.extraEntries."windows.conf" = ''
    title Windows 11
    sort-key windows
    efi /EFI/Microsoft/Boot/bootmgfw.efi
  '';

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

  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "pcie_aspm=off"
  ];

  boot.blacklistedKernelModules = [
    "iTCO_wdt"
    "iTCO_vendor_support"
  ];

  # ============================================================================
  # NIX
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
  # NIX-LD
  # ============================================================================
  programs.nix-ld.enable = true;

  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
    openssl
    curl

    glib
    gtk3
    pango
    cairo
    atk
    at-spi2-atk
    at-spi2-core
    gdk-pixbuf

    dbus
    expat
    udev

    alsa-lib
    cups

    nspr
    nss

    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
    libxkbfile
    libxkbcommon

    mesa
    libgbm
    libglvnd
    libdrm
  ];

  # ============================================================================
  # CORE
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
      "wheel"
      "networkmanager"
      "video"
      "docker"
      "libvirtd"
      "dialout"
    ];
  };

  # ============================================================================
  # DESKTOP
  # ============================================================================
  services.xserver = {
    enable = true;
    xkb.layout = "fr";
  };

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

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
  # HARDWARE
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

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # ============================================================================
  # SECURITY / POLKIT
  # ============================================================================
  security.polkit.enable = true;

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
  # RELIABILITY
  # ============================================================================
  services.logind.settings.Login.KillUserProcesses = true;

  systemd.settings.Manager = {
    DefaultTimeoutStopSec = "15s";
  };

  # ============================================================================
  # QoL
  # ============================================================================
  programs.zoxide.enable = true;
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  services.logrotate.enable = true;

  home-manager.backupFileExtension = null;

  # ============================================================================
  # PACKAGES
  # ============================================================================
  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    bibata-cursors

    bash vim neovim node2nix
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

    nix-ld
    mesa
    libglvnd
    libdrm

    # Hyprchroma plugin package
    inputs.hyprchroma.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  # Evite les erreurs "source globbing error" (wal files existent toujours)
  systemd.tmpfiles.rules = [
    "d /home/tco/.cache/wal 0755 tco users -"
    "f /home/tco/.cache/wal/colors-hyprland.conf 0644 tco users -"
    "f /home/tco/.cache/wal/colors-foot.ini 0644 tco users -"
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    EDITOR = "vim";
  };

  system.stateVersion = "24.05";
}
