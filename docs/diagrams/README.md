# Architecture Diagrams

PlantUML source diagrams for the `setup-os` NixOS configuration. All diagrams share the same dark color scheme (Slate background `#0f172a`, teal accent `#94e2d5`).

Pre-generated PNGs live in [`png/`](./png/). To regenerate locally:

```bash
nix shell nixpkgs#plantuml --command plantuml -tpng -o ./png ./*.puml
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

## Rofi Launcher Flow

Sequence diagram of the two Rofi launch paths: the sidebar launcher (`rofi-push.sh` → `column-tco.rasi`) and the app grid (`rofi-grid.sh` → `apps-grid.rasi`), including the Hyprland gap and blur manipulations each performs.

![Rofi launcher flow](https://raw.githubusercontent.com/RomeoCavazza/setup-os/main/docs/diagrams/png/rofi-launcher-flow.png)

---

## Development Tooling

Development environments managed through Home Manager — Rust, Python, web tooling, editors, AI/LLM stack — alongside the optional domain app modules for CAD, embedded, and data work.

![Development tooling](https://raw.githubusercontent.com/RomeoCavazza/setup-os/main/docs/diagrams/png/dev-tooling.png)
