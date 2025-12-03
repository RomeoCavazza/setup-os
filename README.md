<h1 align="center">Setup-OS</h1>

<p align="center">
  <strong>Configurations Linux centralisées : Arch, NixOS et Rocky Linux</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Hyprland-58E1FF?style=for-the-badge&logo=hyprland&logoColor=white" alt="Hyprland">
  <img src="https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white" alt="Docker">
  <img src="https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white" alt="PostgreSQL">
  <img src="https://img.shields.io/badge/Ollama-000000?style=for-the-badge&logo=ollama&logoColor=white" alt="Ollama">
</p>

---

## Structure

```
setup-os/
├── nixos/           # Configuration déclarative + modules
├── arch-linux/      # Dotfiles + scripts
└── rocky-linux/     # Documentation RHEL
```

---

## <img src="assets/nixos.png" alt="NixOS" width="28"> NixOS

<img src="assets/fastfetch-nixos.png" alt="NixOS" width="500">

Configuration déclarative avec Flakes, Hyprland et modules système.

[nixos-iso](https://channels.nixos.org/nixos-25.05/latest-nixos-graphical-x86_64-linux.iso) · [documentation](nixos/README.md)

```bash
sudo git clone https://github.com/RomeoCavazza/setup-os.git /etc/nixos
cd /etc/nixos/nixos && sudo nixos-rebuild switch
```

| Module | Services | Ports |
|--------|----------|-------|
| databases.nix | PostgreSQL 17, Redis | 5432, 6379 |
| lamp.nix | Apache, PHP, MariaDB | 80, 3306 |
| observability.nix | Loki, Prometheus, Grafana | 3000, 9090, 3100 |
| ollama.nix | IA locale | 11434 |
| nginx.nix | Reverse proxy | 8081-8083 |

---

## <img src="assets/arch-linux.png" alt="Arch Linux" width="28"> Arch Linux

<img src="assets/fastfetch-arch.png" alt="Arch Linux" width="500">

Dotfiles avec Hyprland, Waybar, Tabby, VSCodium et Ollama.

[arch-iso](https://archlinux.org/download/) · [documentation](arch-linux/README.md)

```bash
cd arch-linux && chmod +x scripts/install.sh && ./scripts/install.sh
```

---

## <img src="assets/rocky.png" alt="Rocky Linux" width="28"> Rocky Linux

<img src="assets/fastfetch-rocky.png" alt="Rocky Linux" width="500">

Distribution entreprise RHEL-compatible avec GNOME.

[rocky-iso](https://rockylinux.org/download) · [documentation](rocky-linux/README.md)

```bash
sudo dd if=rocky-9-gnome.iso of=/dev/sdb bs=4M status=progress
```

---

## Sécurité

Exclus du repo : `hardware-configuration.nix`, `flake.lock`, secrets

---

<p align="center">
  Made by <a href="https://github.com/RomeoCavazza">Romeo Cavazza</a>
</p>
