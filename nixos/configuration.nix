{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    # Core modules
    ./modules/nvidia-prime.nix
    ./modules/virtualisation.nix
    ./modules/emacs.nix
    ./modules/science-data.nix

    # Services
    ./modules/databases.nix
    ./modules/ollama.nix
    ./modules/nginx.nix
    # ./modules/observability.nix  # Active-le uniquement si tu en as besoin
  ];

  # ---------------------------------------------------------------------------
  # Bootloader
  # ---------------------------------------------------------------------------
  boot.loader.systemd-boot = {
    enable = true;
    editor = false;
    configurationLimit = 3; # 1 est très strict; 3 est plus safe.
  };

  boot.loader.efi.canTouchEfiVariables = true;

  # Entrée Windows explicite (et stable)
  boot.loader.systemd-boot.extraEntries."windows.conf" = ''
    title Windows 11
    efi /EFI/Microsoft/Boot/bootmgfw.efi
  '';

  boot.kernelParams = [
    "nvidia-drm.modeset=1"
  ];

  # ---------------------------------------------------------------------------
  # Nix (Best practices)
  # ---------------------------------------------------------------------------
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;

    # Optionnel, mais pratique pour éviter des surprises.
    warn-dirty = false;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # ---------------------------------------------------------------------------
  # Locale & Network
  # ---------------------------------------------------------------------------
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "fr_FR.UTF-8";
  console.keyMap = "fr";

  # ---------------------------------------------------------------------------
  # Users (centraliser les groupes ici: robuste)
  # ---------------------------------------------------------------------------
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

  # ---------------------------------------------------------------------------
  # Desktop
  # ---------------------------------------------------------------------------
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

  # ---------------------------------------------------------------------------
  # Audio / Bluetooth / Graphics
  # ---------------------------------------------------------------------------
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

  # ---------------------------------------------------------------------------
  # Minimal System Packages
  # ---------------------------------------------------------------------------
  environment.systemPackages = with pkgs; [
    vim neovim
    git wget curl
    tree ripgrep fd fzf
    fastfetch btop htop

    kitty foot
    firefox

    wl-clipboard
    pavucontrol
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    EDITOR = "vim";
  };

  # ---------------------------------------------------------------------------
  # State
  # ---------------------------------------------------------------------------
  system.stateVersion = "24.05";
}
