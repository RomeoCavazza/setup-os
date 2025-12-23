{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Data & Notes
    obsidian
    n8n
    dbeaver-bin

    # IoT / Embedded
    arduino-ide
    arduino-cli
    esptool
    minicom

    # Monitoring (packages only; services are better managed in dedicated modules)
    influxdb2
    grafana

    # CUDA toolkit (tools; CUDA runtime/driver comes from your NVIDIA stack)
    cudatoolkit
  ];
}
