{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    rofi-wayland
    nemo
    waybar
    procps
  ];

  services.gvfs.enable = true;
  services.udisks2.enable = true;

  programs.thunar.enable = true;
}
