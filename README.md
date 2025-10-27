# Setup-OS

![Linux](https://img.shields.io/badge/Linux-FCC624?logo=linux&logoColor=black)
![Arch Linux](https://img.shields.io/badge/Arch%20Linux-1793D1?logo=archlinux&logoColor=white)
![NixOS](https://img.shields.io/badge/NixOS-5277C3?logo=nixos&logoColor=white)
![Rocky Linux](https://img.shields.io/badge/Rocky%20Linux-10B981?logo=rockylinux&logoColor=white)
![Hyprland](https://img.shields.io/badge/Hyprland-44586a?logo=hyprland&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?logo=postgresql&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white)

Repository centralisé pour configurations Linux — **Arch**, **NixOS** et **Rocky Linux** — avec Hyprland, dotfiles et stack de développement.

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
└── rocky-linux/               # ISO Rocky Linux
    └── rocky-10-gnome.iso
```

---

## 🔗 Liens ISO Officiels

Télécharger les ISO des distributions officielles :

- **Arch Linux** : [https://archlinux.org/download/](https://archlinux.org/download/)
- **NixOS** : [https://nixos.org/download/](https://nixos.org/download/)
- **Rocky Linux** : [https://rockylinux.org/download](https://rockylinux.org/download)

---

## 🚀 Quick Start

### NixOS

```bash
sudo cp -r /etc/nixos /etc/nixos-backup-$(date +%Y%m%d)
sudo git clone https://github.com/RomeoCavazza/setup-os.git /etc/nixos
cd /etc/nixos/nixos
sudo nixos-rebuild switch
```

**Modules** : PostgreSQL, Redis, Ollama, observabilité (Loki/Prometheus/Grafana), LAMP

### Arch Linux

```bash
cd arch-linux
chmod +x scripts/install.sh
./scripts/install.sh
```

**Inclut** : Hyprland, Waybar, Tabby, VSCodium, Ollama

### Rocky Linux

```bash
sudo dd if=rocky-linux/rocky-10-gnome.iso of=/dev/sdb bs=4M status=progress
```

---

## 📋 Modules NixOS

| Module | Services | Ports |
|--------|----------|-------|
| `lamp.nix` | Apache + PHP + MariaDB | 80, 3306 |
| `observability.nix` | Loki + Prometheus + Grafana | 3000, 9090, 3100 |
| `ollama.nix` | IA locale | 11434 |
| `streamlit.nix` | Apps Streamlit | 8501 |

```nix
imports = [
  ./modules/observability.nix
  ./modules/ollama.nix
];
```

---

## 📖 Documentation

- ❄️ [NixOS](nixos/README.md)
- 🐧 [Arch Linux](arch-linux/README.md)
- 🪨 [Rocky Linux](rocky-linux/README.md)

---

## 🔒 Sécurité

⚠️ **Exclus** (`.gitignore`) : `hardware-configuration.nix`, `flake.lock`, secrets
