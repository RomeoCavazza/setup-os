{ config, lib, pkgs, ... }:

{
  # Service Ollama (API locale sur 127.0.0.1:11434)
  services.ollama = {
    enable = true;
    host = "127.0.0.1";
    port = 11434;

    # --- Accélération (décommente UNE seule ligne si besoin) ---
    # acceleration = "cuda"; # NVIDIA (nécessite drivers + CUDA)
    # acceleration = "rocm"; # AMD (ROCm support)
    # -----------------------------------------------------------

    # Models téléchargés seront gérés par `ollama pull ...`
  };

  # Client CLI utile (ollama) + jq pour tester l’API
  environment.systemPackages = with pkgs; [
    ollama
    jq
  ];

  # Optionnel: ouvrir le port si tu veux y accéder depuis le LAN
  # (Déconseillé en dev — laisse l'écoute sur 127.0.0.1)
  # networking.firewall.allowedTCPPorts = [ 11434 ];
}
