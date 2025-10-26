# /etc/nixos/modules/nginx.nix
{ config, pkgs, lib, ... }:

{
  services.nginx = {
    enable = true;

    # Bonnes pratiques (timeouts/headers/gzip, etc.)
    recommendedProxySettings = true;
    recommendedGzipSettings  = true;

    virtualHosts = {
      # ---- localhost -> Apache :80
      "localhost-proxy" = {
        serverName = "localhost";
        listen = [ { addr = "127.0.0.1"; port = 8081; ssl = false; } ];
        locations = {
          "/" = {
            proxyPass       = "http://127.0.0.1:80";
            proxyWebsockets = true;
            extraConfig = ''
              # Passe exactement le Host attendu par Apache pour ce vhost
              proxy_set_header Host              localhost;
              proxy_set_header X-Forwarded-Host  localhost;

              proxy_set_header X-Real-IP         $remote_addr;
              proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
            '';
          };

          # Répond 200 même sans passer par Apache
          "=/" = { return = "200 'ok'\n"; extraConfig = "add_header Content-Type text/plain;"; };

          "/health" = { return = "200 'ok'\n"; extraConfig = "add_header Content-Type text/plain;"; };
        };
      };

      # ---- dev.localhost -> Apache :80
      "dev.localhost-proxy" = {
        serverName = "dev.localhost";
        listen = [ { addr = "127.0.0.1"; port = 8082; ssl = false; } ];
        locations = {
          "/" = {
            proxyPass       = "http://127.0.0.1:80";
            proxyWebsockets = true;
            extraConfig = ''
              proxy_set_header Host              dev.localhost;
              proxy_set_header X-Forwarded-Host  dev.localhost;

              proxy_set_header X-Real-IP         $remote_addr;
              proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
            '';
          };

          "=/" = { return = "200 'ok'\n"; extraConfig = "add_header Content-Type text/plain;"; };

          "/health" = { return = "200 'ok'\n"; extraConfig = "add_header Content-Type text/plain;"; };
        };
      };

      # ---- streamlit.localhost -> Streamlit :8501
      "streamlit.localhost-proxy" = {
        serverName = "streamlit.localhost";
        listen = [ { addr = "127.0.0.1"; port = 8083; ssl = false; } ];
        locations = {
          "/" = {
            proxyPass       = "http://127.0.0.1:8501";
            proxyWebsockets = true;
            extraConfig = ''
              proxy_set_header Host              streamlit.localhost;
              proxy_set_header X-Forwarded-Host  streamlit.localhost;

              proxy_set_header X-Real-IP         $remote_addr;
              proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
            '';
          };

          "=/" = { return = "200 'ok'\n"; extraConfig = "add_header Content-Type text/plain;"; };

          "/health" = { return = "200 'ok'\n"; extraConfig = "add_header Content-Type text/plain;"; };
        };
      };
    };
  };

  # Ouvre 8081/8082/8083 si le pare-feu est actif
  networking.firewall.allowedTCPPorts = [ 8081 8082 8083 ];
}
