# /etc/nixos/modules/nvidia-prime.nix
{ config, pkgs, lib, ... }:

{
  hardware.nvidia = {
    modesetting.enable = true;
    # Power Management: False often yields better performance/stability on desktops/high-end laptops
    powerManagement.enable = false; 
    powerManagement.finegrained = false;
    
    # Use proprietary drivers (usually more stable for CUDA 12+)
    open = false; 
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production; 

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      # VERIFY IDs with `lspci` if X11 fails to start!
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:2:0:0"; 
    };
  };
}
