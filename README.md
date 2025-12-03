<h1 align="center">🐧 Setup-OS</h1>

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

## Structure

```
setup-os/
├── nixos/
├── arch-linux/
└── rocky-linux/
```

---

## Distributions

### <img src="assets/nixos.png" alt="NixOS" width="28"> NixOS

Configuration déclarative avec Flakes, Hyprland et modules système.

[**nixos-iso**](https://releases.nixos.org/nixos/24.05/nixos-gnome-24.05.5695.59fb44bbd20-x86_64-linux.iso) · [Documentation](nixos/README.md)

```bash
sudo cp -r /etc/nixos /etc/nixos-backup-$(date +%Y%m%d)
sudo git clone https://github.com/RomeoCavazza/setup-os.git /etc/nixos
cd /etc/nixos/nixos
sudo nixos-rebuild switch
```

**Modules disponibles** :

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

<p align="center">
  <img src="assets/fastfetch-nixos.png" alt="NixOS Fastfetch" width="600">
</p>

---

### <img src="assets/arch-linux.png" alt="Arch Linux" width="28"> Arch Linux

Dotfiles avec Hyprland, Waybar, Tabby, VSCodium et Ollama.

[**arch-iso**](https://archlinux.org/download/) · [Documentation](arch-linux/README.md)

```bash
cd arch-linux
chmod +x scripts/install.sh
./scripts/install.sh
```

<p align="center">
  <img src="assets/fastfetch-arch.png" alt="Arch Fastfetch" width="600">
</p>

---

### <img src="assets/rocky.png" alt="Rocky Linux" width="28"> Rocky Linux

Distribution entreprise RHEL-compatible.

[**rocky-iso**](https://rockylinux.org/download) · [Documentation](rocky-linux/README.md)

```bash
sudo dd if=rocky-linux/rocky-10-gnome.iso of=/dev/sdb bs=4M status=progress
```

<p align="center">
  <img src="assets/fastfetch-rocky.png" alt="Rocky Fastfetch" width="600">
</p>

---

## Sécurité

**Exclus** (`.gitignore`) : `hardware-configuration.nix`, `flake.lock`, secrets

---

<p align="center">
  Made by <a href="https://github.com/RomeoCavazza">Romeo Cavazza</a>
</p>
