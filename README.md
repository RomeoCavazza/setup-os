<h1 align="center">Setup-OS</h1>

<p align="center">
  <strong>Configurations Linux centralisées : Arch, NixOS et Rocky Linux</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Arch_Linux-1793D1?style=for-the-badge&logo=archlinux&logoColor=white" alt="Arch Linux">
  <img src="https://img.shields.io/badge/NixOS-5277C3?style=for-the-badge&logo=nixos&logoColor=white" alt="NixOS">
  <img src="https://img.shields.io/badge/Rocky_Linux-10B981?style=for-the-badge&logo=rockylinux&logoColor=white" alt="Rocky Linux">
  <img src="https://img.shields.io/badge/Hyprland-58E1FF?style=for-the-badge&logo=hyprland&logoColor=white" alt="Hyprland">
  <img src="https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white" alt="Docker">
</p>

---

## Distributions

<table>
<tr>
<td width="33%" align="center">
<img src="assets/nixos.png" alt="NixOS" width="60"><br>
<strong>NixOS</strong><br>
<a href="https://channels.nixos.org/nixos-25.05/latest-nixos-graphical-x86_64-linux.iso">nixos-iso</a> · <a href="nixos/README.md">docs</a>
</td>
<td width="33%" align="center">
<img src="assets/arch-linux.png" alt="Arch Linux" width="60"><br>
<strong>Arch Linux</strong><br>
<a href="https://archlinux.org/download/">arch-iso</a> · <a href="arch-linux/README.md">docs</a>
</td>
<td width="33%" align="center">
<img src="assets/rocky.png" alt="Rocky Linux" width="60"><br>
<strong>Rocky Linux</strong><br>
<a href="https://rockylinux.org/download">rocky-iso</a> · <a href="rocky-linux/README.md">docs</a>
</td>
</tr>
</table>

---

## Structure

```
setup-os/
├── nixos/           # Configuration déclarative + modules
├── arch-linux/      # Dotfiles + scripts
└── rocky-linux/     # Documentation RHEL
```

---

## NixOS

Configuration déclarative avec Flakes, Hyprland et modules système.

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

<p align="center">
  <img src="assets/fastfetch-nixos.png" alt="NixOS" width="550">
</p>

---

## Arch Linux

Dotfiles avec Hyprland, Waybar, Tabby, VSCodium et Ollama.

```bash
cd arch-linux && chmod +x scripts/install.sh && ./scripts/install.sh
```

<p align="center">
  <img src="assets/fastfetch-arch.png" alt="Arch Linux" width="550">
</p>

---

## Rocky Linux

Distribution entreprise RHEL-compatible avec GNOME.

```bash
sudo dd if=rocky-9-gnome.iso of=/dev/sdb bs=4M status=progress
```

<p align="center">
  <img src="assets/fastfetch-rocky.png" alt="Rocky Linux" width="550">
</p>

---

## Sécurité

Exclus du repo : `hardware-configuration.nix`, `flake.lock`, secrets

---

<p align="center">
  Made by <a href="https://github.com/RomeoCavazza">Romeo Cavazza</a>
</p>
