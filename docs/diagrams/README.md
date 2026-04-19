# Architecture Diagrams

This directory keeps every diagram artifact together:

- [`puml/`](puml/) contains the PlantUML sources.
- [`carbon/`](carbon/) contains the generated TreeView HTML views and their renderer.
- [`png/`](png/) contains the committed PNG renders used by README and wiki pages.

To regenerate the PlantUML PNGs locally:

```bash
cd docs/diagrams/puml
nix shell nixpkgs#plantuml --command plantuml -tpng -o ../png ./*.puml
```

To regenerate the Carbon-style repository maps:

```bash
node docs/diagrams/carbon/render-code-map.mjs
```

---

## Flake Structure

Overview of the ten flake inputs and the single `nixosConfigurations.nixos` output, showing how system config, Home Manager, and secrets wiring compose into one atomic build.

![Flake structure](https://raw.githubusercontent.com/RomeoCavazza/setup-os/main/docs/diagrams/png/flake-outputs.png)

---

## System Architecture

`configuration.nix` as the NixOS entry point, with all active system modules branching off from it — GPU driver, virtualisation, backups, databases, observability, and more.

![System architecture](https://raw.githubusercontent.com/RomeoCavazza/setup-os/main/docs/diagrams/png/system-architecture.png)

---

## Display, Audio & Connectivity

GDM session selection, dual XDG portal configuration (Hyprland + GTK), and the Pipewire audio stack with ALSA and PulseAudio compatibility layers.

![Display and audio](https://raw.githubusercontent.com/RomeoCavazza/setup-os/main/docs/diagrams/png/display-audio.png)

---

## User Layer — Home Manager

How `home.nix` wires dotfiles from the repository into the user environment via `home.file` symlinks, alongside package installation, GTK theming, and PyWal template deployment.

![User layer](https://raw.githubusercontent.com/RomeoCavazza/setup-os/main/docs/diagrams/png/user-layer.png)

---

## Theme Propagation — Seaglass

How the Seaglass teal accent (`#94E2D5`) flows from `seaglass.conf` into Hyprland, Waybar, Rofi, Foot terminal, and GTK — propagated at the config layer, not injected at runtime.

![Theme flow](https://raw.githubusercontent.com/RomeoCavazza/setup-os/main/docs/diagrams/png/theme-flow.png)

---

## Waybar & Rofi Integration

How `configuration.nix` wires Hyprland, Waybar, and Rofi together, with the runtime scripts (`WaybarCava.sh`, `activeapp.sh`, `rofi-push.sh`, `rofi-grid.sh`) and their styling dependencies.

![Integration logic](https://raw.githubusercontent.com/RomeoCavazza/setup-os/main/docs/diagrams/png/integration-logic.png)

---

## Observability Flow

End-to-end monitoring and documentation pipeline: metrics collection, logs
shipping, dashboard rendering, and snapshot publication.

![Observability flow](https://raw.githubusercontent.com/RomeoCavazza/setup-os/main/docs/diagrams/png/observability.png)
