{ config, pkgs, ... }:

{
  # ============================================================================
  # GUI PACKAGES
  # ============================================================================
  environment.systemPackages = with pkgs; [
    rofi                 # App Launcher
    waybar               # Status Bar
    networkmanagerapplet # Tray Icon
    
    # File Managers
    nemo
    
    # System Tools
    procps
  ];

  # ============================================================================
  # FILE SYSTEM SERVICES
  # ============================================================================
  services.gvfs.enable = true;    # Virtual Filesystem (Trash, Mounts)
  services.udisks2.enable = true; # Disk Management
  programs.thunar.enable = true;  # Fallback FM
}
