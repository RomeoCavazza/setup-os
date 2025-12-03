<p align="center">
  <img src="../assets/arch-linux.png" alt="Arch Linux" width="80">
</p>

<h1 align="center">Arch Linux Dotfiles</h1>

<p align="center">
  <strong>Configuration avec Hyprland, Waybar et Tabby</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Arch_Linux-1793D1?style=for-the-badge&logo=archlinux&logoColor=white" alt="Arch Linux">
  <img src="https://img.shields.io/badge/Hyprland-58E1FF?style=for-the-badge&logo=hyprland&logoColor=white" alt="Hyprland">
  <img src="https://img.shields.io/badge/Waybar-1a1b26?style=for-the-badge&logo=wayland&logoColor=white" alt="Waybar">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Tabby-FCD535?style=for-the-badge&logo=terminal&logoColor=black" alt="Tabby">
  <img src="https://img.shields.io/badge/VSCodium-2F80ED?style=for-the-badge&logo=vscodium&logoColor=white" alt="VSCodium">
  <img src="https://img.shields.io/badge/Ollama-000000?style=for-the-badge&logo=ollama&logoColor=white" alt="Ollama">
</p>

---

## Télécharger l'ISO

[**arch-iso**](https://archlinux.org/download/)

---

## Structure

```
arch-linux/
├── dotfiles/
│   ├── hypr/
│   │   └── hyprland.conf
│   ├── waybar/
│   │   ├── config.jsonc
│   │   └── style.css
│   └── tabby/
│       ├── config.yaml
│       └── settings.json
└── scripts/
    └── install.sh
```

---

## Installation

### Prérequis

Arch Linux avec **paru** (AUR helper)

```bash
git clone https://aur.archlinux.org/paru.git
cd paru && makepkg -si
```

### Installation automatique

```bash
cd arch-linux
chmod +x scripts/install.sh
./scripts/install.sh
```

**Installe** : Hyprland, Waybar, Tabby, VSCodium, Ollama, toolchains (Rust, Node.js)

---

## Configuration

### Hyprland

- **Layout** : dwindle
- **Gaps** : 8px (in), 18px (out)
- **Workspaces** : 5 (F1-F5)

**Raccourcis** : `Super + Return` (terminal), `Super + Tab` (files), `Super + F` (float)

### Waybar

Modules : clock, workspaces, network, battery, memory, temperature

**Theme** : Catppuccin Mocha

### Tabby

Configuration terminal avec profils et shortcuts

---

## Paquets

- hyprland, waybar, tabby
- vscodium, ollama
- zsh, kitty, neovim
- nodejs, rust, cargo

---

<p align="center">
  <img src="../assets/fastfetch-arch.png" alt="Arch Fastfetch" width="600">
</p>

---

## Ressources

- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Arch Wiki](https://wiki.archlinux.org/)

---

<p align="center">
  Made by <a href="https://github.com/RomeoCavazza">Romeo Cavazza</a>
</p>
