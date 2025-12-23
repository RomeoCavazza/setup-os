{ config, lib, ... }:

{
  # Define custom option for flexibility
  options.tmpfiles.extraRules = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [];
    description = "Additional tmpfiles rules appended to defaults.";
  };

  config = {
    systemd.tmpfiles.rules = [
      # Service Directories (Ensure existence and permissions)
      "d /var/www 0755 wwwrun wwwrun -"
      "d /var/lib/mysql 0750 mysql mysql -"
      "d /var/lib/promtail 0750 promtail promtail -"
      "d /var/lib/grafana 0750 grafana grafana -"
      "d /var/lib/loki 0750 loki loki -"

      # User Config Directories
      "d /home/tco/.config 0755 tco users -"
      "d /home/tco/.config/hypr 0755 tco users -"
      "d /home/tco/.config/waybar 0755 tco users -"
    ] ++ config.tmpfiles.extraRules;
  };
}
