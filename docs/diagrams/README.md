# Architecture Diagrams


Pre-generated PNGs live in [`../assets/diagrams/`](../assets/diagrams/). To regenerate locally:

```bash
nix shell nixpkgs#plantuml --command plantuml -tpng -o ../assets/diagrams ./*.puml
```

---

## Flake Structure

Overview of the ten flake inputs and the single `nixosConfigurations.nixos` output, showing how system config, Home Manager, and secrets wiring compose into one atomic build.

![Flake structure](https://raw.githubusercontent.com/RomeoCavazza/setup-os/main/docs/assets/diagrams/flake-outputs.png)

---

## System Architecture

`configuration.nix` as the NixOS entry point, with all active system modules branching off from it — GPU driver, virtualisation, backups, databases, observability, and more.

![System architecture](https://raw.githubusercontent.com/RomeoCavazza/setup-os/main/docs/assets/diagrams/system-architecture.png)

---

## Display, Audio & Connectivity

GDM session selection, dual XDG portal configuration (Hyprland + GTK), and the Pipewire audio stack with ALSA and PulseAudio compatibility layers.

![Display and audio](https://raw.githubusercontent.com/RomeoCavazza/setup-os/main/docs/assets/diagrams/display-audio.png)

---

## User Layer — Home Manager

How `home.nix` wires dotfiles from the repository into the user environment via `home.file` symlinks, alongside package installation, GTK theming, and PyWal template deployment.

![User layer](https://raw.githubusercontent.com/RomeoCavazza/setup-os/main/docs/assets/diagrams/user-layer.png)

---

## Theme Propagation — Seaglass

How the Seaglass teal accent (`#94E2D5`) flows from `seaglass.conf` into Hyprland, Waybar, Rofi, Foot terminal, and GTK — propagated at the config layer, not injected at runtime.

![Theme flow](https://raw.githubusercontent.com/RomeoCavazza/setup-os/main/docs/assets/diagrams/theme-flow.png)

---

## Waybar & Rofi Integration

How `configuration.nix` wires Hyprland, Waybar, and Rofi together, with the runtime scripts (`WaybarCava.sh`, `activeapp.sh`, `rofi-push.sh`, `rofi-grid.sh`) and their styling dependencies.

![Integration logic](https://raw.githubusercontent.com/RomeoCavazza/setup-os/main/docs/assets/diagrams/integration-logic.png)

---


---


## Observability Flow

End-to-end monitoring and documentation pipeline: metrics collection, logs
shipping, dashboard rendering, and snapshot publication.

![Observability flow](https://raw.githubusercontent.com/RomeoCavazza/setup-os/main/docs/assets/diagrams/observability.png)
