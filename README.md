# Setup-OS

[![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)](https://kernel.org)
[![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793D1?style=for-the-badge&logo=archlinux&logoColor=white)](https://archlinux.org)
[![NixOS](https://img.shields.io/badge/NixOS-5277C3?style=for-the-badge&logo=nixos&logoColor=white)](https://nixos.org)
[![Rocky Linux](https://img.shields.io/badge/Rocky_Linux-10B981?style=for-the-badge&logo=rockylinux&logoColor=white)](https://rockylinux.org)

[![Hyprland](https://img.shields.io/badge/Hyprland-58E1FF?style=flat-square&logo=hyprland&logoColor=white)](https://hyprland.org)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=flat-square&logo=postgresql&logoColor=white)](https://postgresql.org)
[![Redis](https://img.shields.io/badge/Redis-DC382D?style=flat-square&logo=redis&logoColor=white)](https://redis.io)
[![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat-square&logo=docker&logoColor=white)](https://docker.com)
[![Ollama](https://img.shields.io/badge/Ollama-000000?style=flat-square&logo=ollama&logoColor=white)](https://ollama.ai)

> Repository centralisé pour configurations Linux — **Arch**, **NixOS** et **Rocky Linux** — avec Hyprland, dotfiles et stack de développement.

---

## 📁 Structure

```
setup-os/
├── nixos/                      # Configuration NixOS déclarative
│   ├── config/hypr/           # Hyprland + Waybar
│   ├── modules/               # Modules système
│   ├── configuration.nix
│   └── flake.nix
├── arch-linux/                 # Dotfiles Arch
│   ├── dotfiles/
│   └── scripts/
└── rocky-linux/               # Rocky Linux
    └── README.md
```

---

## 💿 Téléchargement des ISO

| Distribution | Lien de téléchargement |
|--------------|------------------------|
| ❄️ **NixOS 24.05** | [📥 nixos-gnome-24.05.5695.iso](https://releases.nixos.org/nixos/24.05/nixos-gnome-24.05.5695.59fb44bbd20-x86_64-linux.iso) |
| 🐧 **Arch Linux** | [📥 archlinux.org/download](https://archlinux.org/download/) |
| 🪨 **Rocky Linux** | [📥 rockylinux.org/download](https://rockylinux.org/download) |

---

## 🚀 Quick Start

### ❄️ NixOS

```bash
sudo cp -r /etc/nixos /etc/nixos-backup-$(date +%Y%m%d)
sudo git clone https://github.com/RomeoCavazza/setup-os.git /etc/nixos
cd /etc/nixos/nixos
sudo nixos-rebuild switch
```

**Modules** : PostgreSQL, Redis, Ollama, observabilité (Loki/Prometheus/Grafana), LAMP

### 🐧 Arch Linux

```bash
cd arch-linux
chmod +x scripts/install.sh
./scripts/install.sh
```

**Inclut** : Hyprland, Waybar, Tabby, VSCodium, Ollama

### 🪨 Rocky Linux

```bash
sudo dd if=rocky-linux/rocky-10-gnome.iso of=/dev/sdb bs=4M status=progress
```

---

## 📋 Modules NixOS

| Module | Services | Ports |
|--------|----------|-------|
| `databases.nix` | PostgreSQL 17 + Redis | 5432, 6379 |
| `lamp.nix` | Apache + PHP + MariaDB | 80, 3306 |
| `launcher.nix` | Rofi + Nemo + Waybar | — |
| `nginx.nix` | Reverse proxy | 8081, 8082, 8083 |
| `nvidia-prime.nix` | NVIDIA PRIME (optionnel) | — |
| `observability.nix` | Loki + Prometheus + Grafana | 3000, 9090, 3100 |
| `ollama.nix` | IA locale | 11434 |
| `streamlit.nix` | Apps Streamlit | 8501 |
| `tmpfiles.nix` | Règles tmpfiles systemd | — |

```nix
imports = [
  ./modules/databases.nix
  ./modules/observability.nix
  ./modules/ollama.nix
];
```

---

## 📖 Documentation

| OS | README |
|----|--------|
| ❄️ NixOS | [nixos/README.md](nixos/README.md) |
| 🐧 Arch Linux | [arch-linux/README.md](arch-linux/README.md) |
| 🪨 Rocky Linux | [rocky-linux/README.md](rocky-linux/README.md) |

---

## 🔒 Sécurité

⚠️ **Exclus** (`.gitignore`) : `hardware-configuration.nix`, `flake.lock`, secrets
