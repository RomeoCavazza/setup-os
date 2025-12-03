<p align="center">
  <img src="../assets/nixos.png" alt="NixOS" width="80">
</p>

<h1 align="center">NixOS Configuration</h1>

<p align="center">
  <strong>Configuration déclarative et modulaire avec Hyprland</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/NixOS_24.05-5277C3?style=for-the-badge&logo=nixos&logoColor=white" alt="NixOS">
  <img src="https://img.shields.io/badge/Hyprland-58E1FF?style=for-the-badge&logo=hyprland&logoColor=white" alt="Hyprland">
  <img src="https://img.shields.io/badge/Flakes-7EBAE4?style=for-the-badge&logo=snowflake&logoColor=white" alt="Flakes">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white" alt="PostgreSQL">
  <img src="https://img.shields.io/badge/Redis-DC382D?style=for-the-badge&logo=redis&logoColor=white" alt="Redis">
  <img src="https://img.shields.io/badge/Grafana-F46800?style=for-the-badge&logo=grafana&logoColor=white" alt="Grafana">
  <img src="https://img.shields.io/badge/Ollama-000000?style=for-the-badge&logo=ollama&logoColor=white" alt="Ollama">
</p>

---

## Télécharger l'ISO

[**nixos-iso**](https://releases.nixos.org/nixos/24.05/nixos-gnome-24.05.5695.59fb44bbd20-x86_64-linux.iso) · [Autres versions](https://nixos.org/download/)

---

## Structure

```
nixos/
├── config/hypr/              # Hyprland + Waybar
├── modules/                  # Modules système
│   ├── databases.nix         # PostgreSQL + Redis
│   ├── lamp.nix              # Apache + PHP + MariaDB
│   ├── launcher.nix          # Rofi + Nemo + Waybar
│   ├── nginx.nix             # Reverse proxy
│   ├── nvidia-prime.nix      # NVIDIA PRIME (optionnel)
│   ├── observability.nix     # Loki + Prometheus + Grafana
│   ├── ollama.nix            # IA locale
│   ├── streamlit.nix         # Apps Streamlit
│   └── tmpfiles.nix          # Règles tmpfiles systemd
├── configuration.nix
└── flake.nix
```

---

## Installation

```bash
sudo cp -r /etc/nixos /etc/nixos-backup
sudo git clone https://github.com/RomeoCavazza/setup-os.git /etc/nixos
cd /etc/nixos/nixos
sudo nixos-rebuild switch
```

---

## Modules

### Databases (`modules/databases.nix`)

PostgreSQL 17 + PostGIS + Redis

```nix
imports = [ ./modules/databases.nix ];
```

**Ports** : 5432 (PostgreSQL), 6379 (Redis)

### LAMP (`modules/lamp.nix`)

Apache + PHP 8.3 + MariaDB

```nix
imports = [ ./modules/lamp.nix ];
```

**Ports** : 80, 3306

### Launcher (`modules/launcher.nix`)

Rofi-Wayland + Nemo + Waybar + services GVFS/UDisks2

```nix
imports = [ ./modules/launcher.nix ];
```

### Nginx (`modules/nginx.nix`)

Reverse proxy avec virtual hosts (localhost, dev.localhost, streamlit.localhost)

```nix
imports = [ ./modules/nginx.nix ];
```

**Ports** : 8081, 8082, 8083

### NVIDIA PRIME (`modules/nvidia-prime.nix`)

Configuration NVIDIA PRIME pour laptops hybrides (Intel + NVIDIA)

```nix
imports = [ ./modules/nvidia-prime.nix ];
```

**Désactivé par défaut** — décommenter les blocs pour activer

### Observabilité (`modules/observability.nix`)

Loki + Prometheus + Grafana

```nix
imports = [ ./modules/observability.nix ];
```

**Ports** : 3000, 9090, 3100

### Ollama (`modules/ollama.nix`)

IA locale

```nix
imports = [ ./modules/ollama.nix ];
```

**Port** : 11434

### Streamlit (`modules/streamlit.nix`)

Apps Streamlit sandboxées

```nix
imports = [ ./modules/streamlit.nix ];
```

**Port** : 8501

### Tmpfiles (`modules/tmpfiles.nix`)

Règles systemd tmpfiles pour création automatique des répertoires système

```nix
imports = [ ./modules/tmpfiles.nix ];
```

---

## Hyprland

- **Layout** : dwindle
- **Gaps** : 8px (in), 16px (out)
- **Workspaces** : 5 (F1-F5)
- **Theme** : Catppuccin Mocha

**Raccourcis** : `Super + Return` (terminal), `Super + Q` (fermer), `Super + F` (float)

---

## Services

| Service | Port |
|---------|------|
| PostgreSQL | 5432 |
| Redis | 6379 |
| Ollama | 11434 |
| Grafana | 3000 |
| Prometheus | 9090 |
| Nginx | 8081, 8082, 8083 |

---

<p align="center">
  <img src="../assets/fastfetch-nixos.png" alt="NixOS Fastfetch" width="600">
</p>

---

## Ressources

- [NixOS Wiki](https://nixos.wiki/)
- [Hyprland Wiki](https://wiki.hyprland.org/)

---

<p align="center">
  Made by <a href="https://github.com/RomeoCavazza">Romeo Cavazza</a>
</p>
