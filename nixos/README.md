# NixOS Configuration

![NixOS](https://img.shields.io/badge/NixOS-5277C3?logo=nixos&logoColor=white)
![Hyprland](https://img.shields.io/badge/Hyprland-44586a?logo=hyprland&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?logo=postgresql&logoColor=white)
![Redis](https://img.shields.io/badge/Redis-DC382D?logo=redis&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white)
![Grafana](https://img.shields.io/badge/Grafana-F46800?logo=grafana&logoColor=white)

Configuration NixOS déclarative et modulaire pour développement IA, backend Python et observabilité complète. Hyprland (tiling manager) + stack PostgreSQL, Redis, Ollama, monitoring Loki/Prometheus/Grafana.

---

## 📁 Structure

```
nixos/
├── configuration.nix                  # Configuration système principale
├── flake.nix                          # Flake déclaratif NixOS 25.05
├── hardware-configuration.nix.backup  # ⚠️ Ne pas versionner (UUID)
├── config/
│   └── hypr/
│       ├── hyprland.conf              # Configuration Hyprland
│       └── waybar/                    # Barre d'état
│           ├── config.jsonc           # Modules Waybar
│           ├── mocha.css              # Theme Catppuccin Mocha
│           ├── modules.json
│           ├── style.css              # Styles personnalisés
│           ├── WaybarCava.sh          # Audio visualizer (cava)
│           └── waybar.png             # Icônes custom
└── modules/
    ├── lamp.nix                       # Apache + PHP + MariaDB
    ├── observability.nix              # Loki + Prometheus + Grafana
    ├── ollama.nix                     # IA locale (Llama/Mistral)
    ├── streamlit.nix                  # Apps Streamlit sandboxées
    ├── nginx.nix                      # Reverse proxy
    ├── nvidia-prime.nix               # GPU NVIDIA optimisé
    ├── launcher.nix                   # Rofi + Nemo
    └── tmpfiles.nix                   # Gestion répertoires système
```

---

## 🚀 Installation

### 1. Backup configuration existante

```bash
sudo cp -r /etc/nixos /etc/nixos-backup-$(date +%Y%m%d)
```

### 2. Cloner la configuration

```bash
sudo git clone https://github.com/RomeoCavazza/setup-os.git /etc/nixos
cd /etc/nixos/nixos
```

### 3. Générer hardware-configuration.nix (si nouveau matériel)

```bash
sudo nixos-generate-config --root /
```

### 4. Reconstruire le système

```bash
sudo nixos-rebuild switch
```

---

## 📦 Modules disponibles

### 🌐 LAMP Stack (`modules/lamp.nix`)

Stack web complète : Apache 2.4 + PHP 8.3 + MariaDB 10.11

```nix
imports = [ ./modules/lamp.nix ];
```

**DocumentRoots** :
- `http://localhost/` → `/var/www`
- `http://dev.localhost/` → `/var/www/dev/public`

**Ports** : 80 (Apache), 3306 (MariaDB)

**Extensions PHP** : curl, gd, intl, mysqli, opcache, pdo_mysql, xdebug

**Init SQL** : utilisateur `romeo@localhost` avec DB `testdb`

---

### 📊 Observabilité (`modules/observability.nix`)

Stack monitoring complète : Loki (logs) + Prometheus (métriques) + Grafana (visu)

```nix
imports = [ ./modules/observability.nix ];
```

**Services** :
- **Prometheus** : `http://localhost:9090` (métriques, rétention 15j)
- **Grafana** : `http://localhost:3000` (admin/admin par défaut)
- **Loki** : `http://localhost:3100` (logs TSDB v13, rétention 7j)
- **Promtail** : scrape journald + `/var/log/*.log`
- **Node Exporter** : métriques système (port 9100)

**Datasources Grafana** (préconfigurés) :
- Prometheus `http://localhost:9090`
- Loki `http://localhost:3100`

---

### 🤖 Ollama (`modules/ollama.nix`)

IA locale avec support CUDA/ROCm

```nix
imports = [ ./modules/ollama.nix ];
```

**Endpoint** : `http://127.0.0.1:11434`

**Utilisation** :

```bash
# Télécharger un modèle
ollama pull llama3.2:3b

# Tester l'API
curl http://127.0.0.1:11434/api/generate -d '{
  "model": "llama3.2:3b",
  "prompt": "Bonjour, peux-tu te présenter ?"
}'
```

**Accélération GPU** : décommenter dans `ollama.nix` :
- `acceleration = "cuda";` (NVIDIA)
- `acceleration = "rocm";` (AMD)

---

### 🐍 Streamlit (`modules/streamlit.nix`)

Apps Streamlit sandboxées avec `uv`

```nix
imports = [ ./modules/streamlit.nix ];
```

**App** : `http://127.0.0.1:8501`

**Sandboxing** : DynamicUser, PrivateTmp, NoNewPrivileges, ReadWritePaths limités

---

### 🌐 Nginx (`modules/nginx.nix`)

Reverse proxy + cache + SSL

```nix
imports = [ ./modules/nginx.nix ];
```

**Ports** : 80 (HTTP), 443 (HTTPS)

---

### 🎮 NVIDIA Prime (`modules/nvidia-prime.nix`)

Optimisation GPU hybride Intel/NVIDIA

```nix
imports = [ ./modules/nvidia-prime.nix ];
```

Active `nvidia-offload` pour apps nécessitant CUDA.

---

## 🎨 Hyprland Configuration

### Setup

- **Layout** : dwindle (arbres binaires)
- **Gaps** : 8px (in), 16px (out)
- **Borders** : 2px, rounding 10px
- **Animations** : global + fade (1, 3, default)
- **5 Workspaces** : F1-F5

### Raccourcis principaux

| Touche | Action |
|--------|--------|
| `Super + Return` | Terminal (Foot) |
| `Super + Tab` | Gestionnaire fichiers (Nemo) |
| `Super + &` | Menu (Rofi powermenu) |
| `Super + É` | Launcher (Rofi) |
| `Super + Q` | Fermer fenêtre |
| `Super + F` | Float/Tile toggle |
| `Super + V` | Plein écran |
| `Super + Shift + [Left/Right]` | Échanger fenêtres |

**Waybar** : `config/hypr/waybar/`
- **Theme** : Catppuccin Mocha
- **Audio visualizer** : WaybarCava.sh (cava)

---

## 🛠️ Outils de développement

### Backend & Database

- **Python 3.11** avec libs : FastAPI, uvicorn, SQLAlchemy, Alembic, psycopg, psycopg2, passlib, python-jose
- **PostgreSQL 17** : client, contrib, PostGIS extensions
- **Redis** : serveur local (2GB maxmemory, LRU policy, AOF activé)
- **Node.js 20** + pnpm

### Langages & Build Tools

- **C/C++** : GCC, LLVM latest, CMake, pkg-config
- **Rust** : cargo, rustc
- **Java** : OpenJDK 21 (JAVA_HOME configuré)
- **Go** : golang

### DevOps & Conteneurs

- **Docker** : auto-prune hebdomadaire (`--all --volumes`)
- **direnv** + **nix-direnv** : environnements automatiques
- **starship** : prompt customisé

### Éditeurs

- **VSCode** : extensions Python, Java, Go, Rust, PHP, Lua, Prettier
- **JetBrains IDEA Community** : IDE Java

**Fichier** : `configuration.nix` (section `environment.systemPackages`)

---

## 🔧 Maintenance

### Nettoyage store Nix

```bash
# Nettoyage automatique quotidien (configuré)
nix-collect-garbage --delete-older-than 7d
```

### Rebuild avec flakes

```bash
cd /etc/nixos
sudo nixos-rebuild switch --flake .#nixos
```

### Rollback

```bash
sudo nixos-rebuild switch --rollback
```

### Recherche de paquets

```bash
nix search nixpkgs <package-name>
```

---

## 📊 Services système

| Service | Statut | Port | Command |
|---------|--------|------|---------|
| PostgreSQL | Systemd | 5432 | `sudo systemctl status postgresql` |
| Redis | Systemd | 6379 | `sudo systemctl status redis-insider` |
| Ollama | Systemd | 11434 | `sudo systemctl status ollama` |
| Grafana | Systemd | 3000 | `sudo systemctl status grafana` |
| Prometheus | Systemd | 9090 | `sudo systemctl status prometheus` |
| Loki | Systemd | 3100 | `sudo systemctl status loki` |
| Apache | Systemd | 80 | `sudo systemctl status httpd` |
| MariaDB | Systemd | 3306 | `sudo systemctl status mysql` |

---

## 🐛 Dépannage

### Hyprland ne démarre pas

```bash
# Vérifier logs
journalctl -u display-manager -b

# Reconfigurer permissions
sudo nixos-rebuild switch
```

### PostgreSQL refuse connexions

```bash
# Vérifier auth
sudo cat /etc/postgresql/pg_hba.conf

# Redémarrer
sudo systemctl restart postgresql
```

### Ollama GPU non détecté

```bash
# Vérifier CUDA
nvidia-smi

# Vérifier config
cat /etc/nixos/modules/ollama.nix | grep acceleration
```

---

## 🔒 Sécurité

⚠️ **Fichiers exclus** (`.gitignore`) :
- `hardware-configuration.nix` : UUID disques, interfaces réseau
- `flake.lock` : verrous de dépendances
- Secrets : `.key`, `.pem`, `secrets.nix`

**Firewall** : ports ouverts uniquement pour services activés (ex: 3000, 9090, 3100 si observabilité active)

---

## 📚 Ressources

- [NixOS Wiki](https://nixos.wiki/)
- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Flakes Manual](https://nixos.wiki/wiki/Flakes)
- [Prometheus Docs](https://prometheus.io/docs/)
- [Grafana Docs](https://grafana.com/docs/)

---

⭐ **Cette config est 100% reproductible** — un seul `nixos-rebuild switch` après clonage
