{ config, pkgs, lib, ... }:

{
  # PostgreSQL 17 (local-only)
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_17;
    dataDir = "/var/lib/postgresql/17";

    settings = {
      listen_addresses = "127.0.0.1";
    };

    extensions = [ pkgs.postgis ];

    authentication = lib.mkOverride 10 ''
      # TYPE  DATABASE  USER      ADDRESS         METHOD
      local   all       postgres                  peer
      local   all       all                       md5
      host    all       all       127.0.0.1/32    md5
      host    all       all       ::1/128         md5
    '';
  };

  # Redis (local-only)
  services.redis.servers.insider = {
    enable = true;
    port = 6379;
    bind = "127.0.0.1";

    settings = {
      "appendonly" = "yes";
      "save" = [ "900 1" "300 10" "60 10000" ];
      "maxmemory" = "2gb";
      "maxmemory-policy" = "allkeys-lru";
      "loglevel" = "notice";
      "protected-mode" = "yes";
      "tcp-keepalive" = "60";
      "notify-keyspace-events" = "Ex";
    };
  };
}
