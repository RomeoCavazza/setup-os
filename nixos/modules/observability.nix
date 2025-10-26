{ config, pkgs, lib, ... }:

{
  ############################
  ## Node Exporter
  ############################
  services.prometheus.exporters.node.enable = true;

  ############################
  ## Prometheus
  ############################
  services.prometheus = {
    enable = true;
    # Limite l’empreinte disque
    retentionTime = "15d";

    scrapeConfigs = [
      { job_name = "prometheus";
        static_configs = [{ targets = [ "localhost:9090" ]; }];
      }
      { job_name = "node";
        static_configs = [{ targets = [ "localhost:9100" ]; }];
      }
      { job_name = "loki";
        static_configs = [{ targets = [ "localhost:3100" ]; }];
      }
    ];
  };

  ############################
  ## Loki (TSDB local + rétention)
  ############################
  services.loki = {
    enable = true;
    configuration = {
      auth_enabled = false;
      server.http_listen_port = 3100;

      common = {
        instance_addr = "127.0.0.1";
        path_prefix   = "/var/lib/loki";
        ring.kvstore.store = "inmemory";
        storage.filesystem = {
          chunks_directory = "/var/lib/loki/chunks";
          rules_directory  = "/var/lib/loki/rules";
        };
        replication_factor = 1;
      };

      # TSDB v13 (local FS)
      schema_config.configs = [{
        from         = "2024-01-01";
        store        = "tsdb";
        object_store = "filesystem";
        schema       = "v13";
        index = { prefix = "index_"; period = "24h"; };
      }];

      # Rétention simple via limits (7j)
      limits_config = {
        reject_old_samples         = true;
        reject_old_samples_max_age = "168h";
        retention_period           = "168h";
      };

      # Ruler minimal en local (facultatif, prêt pour ajouter des règles)
      ruler = {
        rule_path = "/var/lib/loki/rules";
        ring.kvstore.store = "inmemory";
        storage = {
          type = "local";
          local = { directory = "/var/lib/loki/rules"; };
        };
      };
    };
  };

  ############################
  ## Promtail
  ############################
  services.promtail = {
    enable = true;
    configuration = {
      server = {
        http_listen_port = 9080;
        grpc_listen_port = 0;
      };

      positions = { filename = "/var/lib/promtail/positions.yaml"; };

      clients = [
        { url = "http://127.0.0.1:3100/loki/api/v1/push"; }
      ];

      scrape_configs = [
        # Journaux systemd
        {
          job_name = "journal";
          journal = {
            max_age = "12h";
            labels = { job = "systemd-journal"; };
          };
          relabel_configs = [
            { source_labels = [ "__journal__systemd_unit" ]; target_label = "unit"; }
          ];
        }

        # /var/log/*.log
        {
          job_name = "varlogs";
          static_configs = [
            {
              targets = [ "localhost" ];
              labels  = { job = "varlogs"; __path__ = "/var/log/*log"; };
            }
          ];
        }
      ];
    };
  };

  # Accès au journal pour promtail + écriture dans /var/lib/promtail
  systemd.services.promtail.serviceConfig = {
    SupplementaryGroups = [ "systemd-journal" ];
    ReadWritePaths      = [ "/var/lib/promtail" ];
  };

  ############################
  ## Grafana
  ############################
  services.grafana = {
    enable = true;
    settings.server = {
      http_addr = "127.0.0.1";
      http_port = 3000;
      domain    = "localhost";
    };
  };

  ############################
  ## (Optionnel) Paquets CLI utiles
  ############################
  environment.systemPackages = with pkgs; [
    grafana
    prometheus
    loki
    promtail
  ];

  ############################
  ## Firewall (si activé)
  ############################
  networking.firewall.allowedTCPPorts = [ 3000 3100 9090 9100 ];
}
