{ config, lib, pkgs, ... }:

{
  services.ollama = {
    enable = true;
    host = "127.0.0.1";
    port = 11434;

    # Disabled by default; set explicitly when needed:
    acceleration = lib.mkDefault null;
    # acceleration = "cuda";
    # acceleration = "rocm";
  };

  environment.systemPackages = with pkgs; [
    ollama
    jq
  ];
}
