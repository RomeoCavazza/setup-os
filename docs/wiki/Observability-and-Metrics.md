<p align="left">
	<img src="https://raw.githubusercontent.com/RomeoCavazza/setup-os/main/docs/assets/logo/graphana.png" alt="Grafana" width="26" />
	<img src="https://raw.githubusercontent.com/RomeoCavazza/setup-os/main/docs/assets/logo/loki.png" alt="Loki" width="26" />
	<img src="https://raw.githubusercontent.com/RomeoCavazza/setup-os/main/docs/assets/logo/prometheus.png" alt="Prometheus" width="26" />
</p>

This page documents the local observability stack and the continuous documentation flow around it.

## Live Snapshots (Core)

### NixOS Metrics
Live cockpit for current pressure and rebuild cost.

![NixOS Metrics Live](https://raw.githubusercontent.com/RomeoCavazza/setup-os/main/docs/assets/live/live-dashboard.png)

### Nix Efficiency
Drift dashboard for freshness, generation debt, and closure efficiency.

![Nix Efficiency](https://raw.githubusercontent.com/RomeoCavazza/setup-os/main/docs/assets/live/nix-efficiency.png)

### Incident Correlation
PSI spikes aligned with journald logs for fast root-cause analysis.

![Incident Dashboard](https://raw.githubusercontent.com/RomeoCavazza/setup-os/main/docs/assets/live/incident-dashboard.png)

Snapshots are updated by automation and committed only when visual delta exceeds 5%.

The three views read as a sequence: health now, drift over time, then incident explanation.

Recent cleanup decisions:

- Removed freshness redundancy from the main cockpit dashboard
- Kept freshness only in the efficiency dashboard
- Applied explicit dual-axis semantics for closure volume (Bytes) vs path count (Count)

## Stack Summary

The stack is intentionally small: Prometheus and Node Exporter handle metrics, Loki and Promtail handle logs, and Grafana ties the signals together.

| Component | Endpoint | Role |
|---|---|---|
| Prometheus | `localhost:9090` | Metrics TSDB and query engine |
| Node Exporter | `localhost:9100` | Host metrics + textfile collector |
| Loki | `localhost:3100` | Centralized logs |
| Promtail | systemd service | Journald scraping + labeling |
| Grafana | `localhost:3000` | Dashboards and correlation UI |

All services are Nix-declared and activated with `nixos-rebuild`.

## Dashboards

`nixos-metrics` tracks live pressure and rebuild health, `nix-efficiency` tracks drift and closure efficiency, and `incident-correlation` links spikes back to logs.

## Key Metrics

These are the signals I watch first when the machine feels slow or stale.

| Metric | Meaning | Typical Use |
|---|---|---|
| `nix_pressure_cpu_avg10` | CPU pressure over 10s window | Detect short saturation events |
| `nix_pressure_io_some_avg10` | IO pressure over 10s window | Spot storage bottlenecks |
| `nix_pressure_mem_some_avg10` | Memory pressure over 10s window | Detect reclaim pressure |
| `nix_closure_bytes` | Current system closure size | Track deployment footprint |
| `nix_closure_paths` | Number of closure paths | Track graph complexity |
| `nix_generations_count` | Retained generations | Manage generation debt |
| `nix_flake_lock_age_seconds` | Flake lock freshness | Detect stale dependency state |

## Log Correlation Labels (Promtail)

Promtail adds a `component` label so dashboard spikes can be matched to the right part of the machine:

- `component="display"` for Hyprland and display stack units
- `component="build"` for Nix build / rebuild units
- `component="system"` as the default fallback

LogQL example:

```logql
{job="systemd-journal",component=~"display|build"}
```

## Continuous Documentation Pipeline

The documentation flow is simple:

1. `grafana-snapshot-sync.timer` runs hourly.
2. Dashboards are captured via headless browser as PNG.
3. New images are compared with previous versions.
4. Only changes over 5% are committed.
5. The resulting update is pushed to git.

Rendered assets path: `docs/assets/live/`.

Operational note: these snapshots are not the live source of truth; they mirror
Grafana state on timer cadence.

## Wiki Integration

The wiki lives in `setup-os.wiki.git` and is linked from the main repo through the `docs/wiki` submodule, so documentation follows the same release flow as the code.

This keeps infra changes, dashboards, and documentation versioned together.
