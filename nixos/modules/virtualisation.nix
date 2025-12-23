{ config, pkgs, ... }:

{
  # Docker
  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      flags = [ "--all" "--volumes" ];
    };
  };

  # KVM / libvirt
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # ARM emulation (build/run aarch64 userspace via binfmt/qemu)
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  environment.systemPackages = with pkgs; [
    docker-compose
    lazydocker
    qemu
    quickemu
  ];
}
