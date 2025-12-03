<p align="center">
  <img src="../assets/nixos.png" alt="NixOS" width="80">
</p>

<h1 align="center">NixOS</h1>

<p align="center">
  <strong>Configuration déclarative et modulaire avec Hyprland</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/NixOS_25.05-5277C3?style=for-the-badge&logo=nixos&logoColor=white" alt="NixOS">
  <img src="https://img.shields.io/badge/Flakes-7EBAE4?style=for-the-badge&logo=snowflake&logoColor=white" alt="Flakes">
  <img src="https://img.shields.io/badge/Hyprland-58E1FF?style=for-the-badge&logo=hyprland&logoColor=white" alt="Hyprland">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white" alt="PostgreSQL">
  <img src="https://img.shields.io/badge/Redis-DC382D?style=for-the-badge&logo=redis&logoColor=white" alt="Redis">
  <img src="https://img.shields.io/badge/Grafana-F46800?style=for-the-badge&logo=grafana&logoColor=white" alt="Grafana">
  <img src="https://img.shields.io/badge/Prometheus-E6522C?style=for-the-badge&logo=prometheus&logoColor=white" alt="Prometheus">
  <img src="https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white" alt="Nginx">
  <img src="https://img.shields.io/badge/Ollama-000000?style=for-the-badge&logo=ollama&logoColor=white" alt="Ollama">
  <img src="https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white" alt="Docker">
</p>

<img src="../assets/fastfetch-nixos.png" alt="NixOS" width="550">

---

## Structure

```
nixos/
├── config/hypr/         # Hyprland + Waybar
├── modules/             # Modules système
├── configuration.nix
└── flake.nix
```

---

## Installation

[Télécharger l'ISO](https://channels.nixos.org/nixos-25.05/latest-nixos-graphical-x86_64-linux.iso)

```bash
sudo cp -r /etc/nixos /etc/nixos-backup
sudo git clone https://github.com/RomeoCavazza/setup-os.git /etc/nixos
cd /etc/nixos/nixos
sudo nixos-rebuild switch
```

---

## Modules

| Module | Description | Ports |
|--------|-------------|-------|
| databases.nix | PostgreSQL 17 + PostGIS + Redis | 5432, 6379 |
| lamp.nix | Apache + PHP 8.3 + MariaDB | 80, 3306 |
| launcher.nix | Rofi + Nemo + Waybar | — |
| nginx.nix | Reverse proxy | 8081-8083 |
| nvidia-prime.nix | NVIDIA PRIME (optionnel) | — |
| observability.nix | Loki + Prometheus + Grafana | 3000, 9090, 3100 |
| ollama.nix | IA locale | 11434 |
| streamlit.nix | Apps Streamlit | 8501 |
| tmpfiles.nix | Règles systemd tmpfiles | — |

### Exemple d'import

```nix
imports = [
  ./modules/databases.nix
  ./modules/observability.nix
  ./modules/ollama.nix
];
```

---

## Hyprland

| Paramètre | Valeur |
|-----------|--------|
| Layout | dwindle |
| Gaps | 8px (in), 16px (out) |
| Workspaces | 5 (F1-F5) |
| Theme | Catppuccin Mocha |

**Raccourcis** : `Super+Return` terminal · `Super+Q` fermer · `Super+F` float

---

## Services

| Service | Port |
|---------|------|
| PostgreSQL | 5432 |
| Redis | 6379 |
| Ollama | 11434 |
| Grafana | 3000 |
| Prometheus | 9090 |
| Nginx | 8081-8083 |

---

---

## Ressources

[NixOS Wiki](https://nixos.wiki/) · [Hyprland Wiki](https://wiki.hyprland.org/)

---

<p align="center">
  Made by <a href="https://github.com/RomeoCavazza">Romeo Cavazza</a>
</p>
