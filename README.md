# Setup-OS

![Linux](https://img.shields.io/badge/Linux-FCC624?logo=linux&logoColor=black)
![Arch Linux](https://img.shields.io/badge/Arch%20Linux-1793D1?logo=archlinux&logoColor=white)
![NixOS](https://img.shields.io/badge/NixOS-5277C3?logo=nixos&logoColor=white)
![Rocky Linux](https://img.shields.io/badge/Rocky%20Linux-10B981?logo=rockylinux&logoColor=white)
![Hyprland](https://img.shields.io/badge/Hyprland-44586a?logo=hyprland&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?logo=postgresql&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white)

Repository centralisé pour mes configurations Linux — **Arch Linux**, **NixOS** et **Rocky Linux** — avec Hyprland, dotfiles et stack complète pour le développement IA et backend.

Ce dépôt regroupe :
- **Configuration NixOS modulaire** — PostgreSQL, Redis, Ollama, stack observabilité (Loki/Prometheus/Grafana), modules LAMP
- **Dotfiles Arch Linux** — Hyprland, Waybar, Tabby avec scripts d'installation automatisés
- **ISO Rocky Linux** — image de référence pour déploiement serveur

---

## 📁 Structure du projet

```
setup-os/
├── nixos/                      # Configuration NixOS déclarative
│   ├── config/
│   │   └── hypr/               # Hyprland + Waybar configs
│   │       ├── hyprland.conf
│   │       └── waybar/
│   │           ├── config.jsonc
│   │           ├── mocha.css   # Theme Catppuccin
│   │           ├── style.css
│   │           └── WaybarCava.sh
│   ├── modules/                # Modules système réutilisables
│   │   ├── lamp.nix            # Apache + PHP + MariaDB
│   │   ├── observability.nix   # Loki + Prometheus + Grafana
│   │   ├── ollama.nix          # IA locale (Llama/Mistral)
│   │   ├── streamlit.nix       # Apps Streamlit sandboxées
│   │   ├── nginx.nix           # Reverse proxy
│   │   ├── nvidia-prime.nix    # GPU NVIDIA
│   │   ├── launcher.nix        # Rofi + Nemo
│   │   └── tmpfiles.nix        # Répertoires système
│   ├── configuration.nix       # Config système principale
│   └── flake.nix               # Flake déclaratif NixOS 25.05
├── arch-linux/                 # Dotfiles Arch + scripts
│   ├── dotfiles/
│   │   ├── hypr/
│   │   │   └── hyprland.conf
│   │   ├── waybar/
│   │   │   ├── config.jsonc
│   │   │   └── style.css
│   │   └── tabby/
│   │       ├── config.yaml
│   │       └── settings.json
│   └── scripts/
│       └── install.sh          # Installation automatique AUR
└── rocky-linux/
    └── rocky-10-gnome.iso      # ISO GNOME Rocky Linux 10
```

---

## 🚀 Quick Start

### NixOS — Configuration déclarative complète

```bash
# Backup existant
sudo cp -r /etc/nixos /etc/nixos-backup-$(date +%Y%m%d)

# Clone config
sudo git clone https://github.com/RomeoCavazza/setup-os.git /etc/nixos
cd /etc/nixos/nixos

# Générer hardware-configuration.nix si nécessaire
sudo nixos-generate-config --root /

# Rebuild système
sudo nixos-rebuild switch
```

**Inclut** : Hyprland, PostgreSQL 17, Redis, Ollama, stack observabilité complète, modules LAMP, outils dev (Python, Node.js, Rust, Go, Java).

### Arch Linux — Dotfiles et Hyprland

```bash
git clone https://github.com/RomeoCavazza/setup-os.git ~/setup-os
cd ~/setup-os/arch-linux
chmod +x scripts/install.sh
./scripts/install.sh
```

**Installe** : Hyprland, Waybar, Tabby, VSCodium, Ollama, toolchains (Rust, Node.js), polices JetBrains Mono.

### Rocky Linux — ISO serveur

Boot depuis `rocky-linux/rocky-10-gnome.iso` ou créer clé USB :

```bash
# Linux
sudo dd if=rocky-linux/rocky-10-gnome.iso of=/dev/sdb bs=4M status=progress
sync

# macOS
sudo dd if=rocky-linux/rocky-10-gnome.iso of=/dev/rdisk2 bs=1m
```

---

## 📋 Modules NixOS disponibles

Chaque module est indépendant et importable dans `configuration.nix` :

| Module | Description | Services | Ports |
|--------|-------------|----------|-------|
| `lamp.nix` | Stack web complète | Apache, PHP 8.3, MariaDB | 80, 3306 |
| `observability.nix` | Monitoring et logs | Loki, Prometheus, Grafana, Promtail | 3000, 9090, 3100 |
| `ollama.nix` | IA locale | Ollama API | 11434 |
| `streamlit.nix` | Apps Streamlit | Streamlit sandboxé | 8501 |
| `nginx.nix` | Reverse proxy | Nginx | 80, 443 |
| `nvidia-prime.nix` | Optimisation GPU | GPU hybride Intel/NVIDIA | — |

**Exemple** : activer observabilité et IA

```nix
# Dans configuration.nix
imports = [
  ./hardware-configuration.nix
  ./modules/observability.nix  # ← Stack monitoring
  ./modules/ollama.nix          # ← IA locale
];
```

---

## 🎨 Hyprland Configuration

Setup minimal clean avec :

- **Layout** : dwindle (arbres binaires)
- **Gaps** : 8px (in), 16px (out)
- **Workspaces** : 5 (F1-F5)
- **Waybar** : Catppuccin Mocha theme
- **Raccourcis** : Super+modifier ergonomiques

**Fichiers** : `nixos/config/hypr/` et `arch-linux/dotfiles/hypr/`

---

## 🛠️ Stack technique

### Backend & Databases
- **Python 3.11** : FastAPI, SQLAlchemy, Alembic, psycopg2
- **PostgreSQL 17** : extensions PostGIS
- **Redis** : 2GB maxmemory, LRU policy
- **Node.js 20** + pnpm

### IA & Data
- **Ollama** : Llama, Mistral, models locaux
- **Streamlit** : apps sandboxées
- **pandas**, **numpy**, **scikit-learn**

### Observabilité
- **Loki** : logs (TSDB v13, rétention 7j)
- **Prometheus** : métriques (rétention 15j)
- **Grafana** : visualisation
- **Promtail** : scraping journald

### DevOps
- **Docker** : auto-prune hebdomadaire
- **direnv** + **nix-direnv** : env auto
- **starship** : prompt customisé

---

## 📖 Documentation détaillée

Consultez les README de chaque OS pour les détails complets :

- 📦 **[NixOS — Configuration & Modules](nixos/README.md)** — Installation, modules, services, mainttenance
- 🐧 **[Arch Linux — Dotfiles](arch-linux/README.md)** — Hyprland, Waybar, Tabby, installation
- 🪨 **[Rocky Linux — ISO](rocky-linux/README.md)** — Création USB, installation, post-install

---

## 🔒 Sécurité

⚠️ **Ne poussez JAMAIS** sur GitHub :

- `hardware-configuration.nix` (UUID disques, interfaces réseau)
- `flake.lock` (verrous de dépendances)
- Clés SSH, tokens, secrets

Le `.gitignore` protège ces fichiers automatiquement.

---

## 🤝 Contribution

Issues et PRs bienvenus pour :
- Nouveaux modules NixOS
- Optimisations Hyprland
- Scripts d'installation
- Améliorations documentation

---

## 📄 License

MIT License — Voir [LICENSE](LICENSE)

---

## 🔗 Liens

[![Portfolio](https://img.shields.io/badge/Portfolio-000000?style=for-the-badge&logo=vercel&logoColor=white)](https://www.romeo-cavazza.dev) [![LinkedIn](https://img.shields.io/badge/LinkedIn-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/romeo-cavazza/) [![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/RomeoCavazza)

---

⭐ **Star si utile** — Config 100% reproductible avec un seul `nixos-rebuild switch`
