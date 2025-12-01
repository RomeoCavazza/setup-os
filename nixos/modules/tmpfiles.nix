{ config, lib, ... }:

{
  options.tmpfiles.extraRules = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [];
    description = "Règles tmpfiles supplémentaires (concaténées aux règles par défaut).";
  };

  config = {
    systemd.tmpfiles.rules = [
      # Répertoire racine web Apache
      "d /var/www 0755 wwwrun wwwrun -"

      # Répertoire MariaDB (normalement créé automatiquement, mais sécurité)
      "d /var/lib/mysql 0750 mysql mysql -"

      # Répertoire promtail
      "d /var/lib/promtail 0750 promtail promtail -"

      # Répertoire Grafana
      "d /var/lib/grafana 0750 grafana grafana -"

      # Répertoire Loki
      "d /var/lib/loki 0750 loki loki -"

      # Répertoires config user (mais plus de symlink Hyprland ici)
      "d /home/tco/.config 0755 tco users -"
      "d /home/tco/.config/hypr 0755 tco users -"
      "d /home/tco/.config/waybar 0755 tco users -"
    ] ++ config.tmpfiles.extraRules;
  };
}
