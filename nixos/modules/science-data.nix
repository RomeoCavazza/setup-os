{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # ==========================================================================
    # KNOWLEDGE & DATABASE MANAGEMENT
    # ==========================================================================
    obsidian    # Note taking / Second Brain
    dbeaver-bin # Universal Database Tool

    # ==========================================================================
    # EMBEDDED SYSTEMS / IOT
    # ==========================================================================
    arduino-ide
    arduino-cli
    esptool     # ESP8266/ESP32 Flasher
    minicom     # Serial Monitor

    # ==========================================================================
    # OBSERVABILITY (CLI/Binaries)
    # ==========================================================================
    # Note: Full services should be declared in systemd units if needed constantly
    influxdb2
    grafana

    # ==========================================================================
    # GPU COMPUTING TOOLS
    # ==========================================================================
    # Provides command line tools (nvcc, etc). 
    # The actual driver is handled by the Nvidia module.
    cudatoolkit
  ];
}
