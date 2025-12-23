{ config, lib, pkgs, ... }:

{
  # ============================================================================
  # OLLAMA SERVICE
  # ============================================================================
  services.ollama = {
    enable = true;
    host = "127.0.0.1";
    port = 11434;

    # Acceleration: Explicitly use the CUDA-enabled package
    package = pkgs.ollama-cuda;
  };

  # ============================================================================
  # TOOLS
  # ============================================================================
  environment.systemPackages = with pkgs; [
    pkgs.ollama-cuda # CLI client
    jq               # JSON parsing for API responses
  ];

  # Networking: Uncomment to expose Ollama to LAN
  # networking.firewall.allowedTCPPorts = [ 11434 ];
}
