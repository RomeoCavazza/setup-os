# ❄️ NixOS Configuration

[![NixOS](https://img.shields.io/badge/NixOS_24.05-5277C3?style=for-the-badge&logo=nixos&logoColor=white)](https://nixos.org)
[![Hyprland](https://img.shields.io/badge/Hyprland-58E1FF?style=for-the-badge&logo=hyprland&logoColor=white)](https://hyprland.org)
[![Flakes](https://img.shields.io/badge/Flakes-7EBAE4?style=for-the-badge&logo=snowflake&logoColor=white)](https://nixos.wiki/wiki/Flakes)

[![PostgreSQL](https://img.shields.io/badge/PostgreSQL_17-4169E1?style=flat-square&logo=postgresql&logoColor=white)](https://postgresql.org)
[![Redis](https://img.shields.io/badge/Redis-DC382D?style=flat-square&logo=redis&logoColor=white)](https://redis.io)
[![Grafana](https://img.shields.io/badge/Grafana-F46800?style=flat-square&logo=grafana&logoColor=white)](https://grafana.com)
[![Prometheus](https://img.shields.io/badge/Prometheus-E6522C?style=flat-square&logo=prometheus&logoColor=white)](https://prometheus.io)
[![Nginx](https://img.shields.io/badge/Nginx-009639?style=flat-square&logo=nginx&logoColor=white)](https://nginx.org)
[![Ollama](https://img.shields.io/badge/Ollama-000000?style=flat-square&logo=ollama&logoColor=white)](https://ollama.ai)
[![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat-square&logo=docker&logoColor=white)](https://docker.com)

> Configuration NixOS déclarative et modulaire avec Hyprland, PostgreSQL, Redis, Ollama, stack observabilité.

---

## 💿 Télécharger l'ISO

| Version | Téléchargement |
|---------|----------------|
| **NixOS 24.05 GNOME** (recommandée) | [📥 nixos-gnome-24.05.5695.iso](https://releases.nixos.org/nixos/24.05/nixos-gnome-24.05.5695.59fb44bbd20-x86_64-linux.iso) |
| Autres versions | [nixos.org/download](https://nixos.org/download/) |

---

## 📁 Structure

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

## 🚀 Installation

```bash
sudo cp -r /etc/nixos /etc/nixos-backup
sudo git clone https://github.com/RomeoCavazza/setup-os.git /etc/nixos
cd /etc/nixos/nixos
sudo nixos-rebuild switch
```

---

## 📦 Modules

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

⚠️ **Désactivé par défaut** — décommenter les blocs pour activer

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

## 🎨 Hyprland

- **Layout** : dwindle
- **Gaps** : 8px (in), 16px (out)
- **Workspaces** : 5 (F1-F5)
- **Theme** : Catppuccin Mocha

**Raccourcis** : `Super + Return` (terminal), `Super + Q` (fermer), `Super + F` (float)

---

## 🛠️ Services

| Service | Port |
|---------|------|
| PostgreSQL | 5432 |
| Redis | 6379 |
| Ollama | 11434 |
| Grafana | 3000 |
| Prometheus | 9090 |
| Nginx | 8081, 8082, 8083 |

---

## 📚 Ressources

- [NixOS Wiki](https://nixos.wiki/)
- [Hyprland Wiki](https://wiki.hyprland.org/)
