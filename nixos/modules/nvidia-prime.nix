{ config, pkgs, lib, ... }:

{
  ###############################################
  ## NVIDIA PRIME — Hyprland / Wayland
  ## --------------------------------------------
  ## Ce module configure :
  ##  - driver NVIDIA propriétaire
  ##  - modesetting + offload PRIME (Intel ↔ NVIDIA)
  ##  - variables d’environnement nécessaires
  ##
  ## ⚠️  ENTIEREMENT COMMENTÉ — NE FAIT RIEN PAR DEFAUT.
  ## Pour l’activer → décommenter les blocs.
  ###############################################

  # services.xserver.videoDrivers = [ "nvidia" "modesetting" ];

  # hardware.graphics = {
  #   enable = true;
  #   enable32Bit = true;
  # };

  # hardware.nvidia = {
  #   modesetting.enable = true;
  #   powerManagement.enable = true;
  #   nvidiaSettings = true;
  #   open = false; # → pilote proprio (plus stable pour Wayland)
  #
  #   prime = {
  #     offload.enable = true;
  #     # ⚠️ Adapter selon `lspci | grep VGA`
  #     intelBusId  = "PCI:0:2:0";
  #     nvidiaBusId = "PCI:2:0:0";
  #   };
  # };

  # environment.sessionVariables = {
  #   __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  #   WLR_NO_HARDWARE_CURSORS   = "1";
  #   LIBVA_DRIVER_NAME         = "nvidia";
  #   GBM_BACKEND               = "nvidia-drm";
  # };

}
