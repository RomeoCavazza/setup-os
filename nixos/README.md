# NixOS Configuration

![NixOS](https://img.shields.io/badge/NixOS-5277C3?logo=nixos&logoColor=white)
![Hyprland](https://img.shields.io/badge/Hyprland-44586a?logo=hyprland&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?logo=postgresql&logoColor=white)
![Redis](https://img.shields.io/badge/Redis-DC382D?logo=redis&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white)

Configuration NixOS déclarative et modulaire avec Hyprland, PostgreSQL, Redis, Ollama, stack observabilité.

---

## 📁 Structure

```
nixos/
├── config/hypr/              # Hyprland + Waybar
├── modules/                  # Modules système
│   ├── lamp.nix
│   ├── observability.nix
│   ├── ollama.nix
│   └── streamlit.nix
├── configuration.nix
└── flake.nix
```

---

## 🔗 Télécharger l'ISO NixOS

📥 [https://nixos.org/download/](https://nixos.org/download/)

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

### LAMP (`modules/lamp.nix`)

Apache + PHP 8.3 + MariaDB

```nix
imports = [ ./modules/lamp.nix ];
```

**Ports** : 80, 3306

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

---

## 📚 Ressources

- [NixOS Wiki](https://nixos.wiki/)
- [Hyprland Wiki](https://wiki.hyprland.org/)

---

⭐ **100% reproductible**
