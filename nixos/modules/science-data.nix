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
    influxdb2
    grafana
  ];
}
