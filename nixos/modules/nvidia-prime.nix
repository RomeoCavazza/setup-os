{ config, lib, pkgs, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;

    # Keep as default; set false if regressions
    open = lib.mkDefault true;

    nvidiaSettings = true;
    nvidiaPersistenced = true;

    powerManagement = {
      enable = true;
      finegrained = true;
    };

    # Default: stable; override in configuration if you explicitly want beta
    package = lib.mkDefault config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:2:0:0";
    };
  };
}
