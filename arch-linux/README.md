<p align="center">
  <img src="../assets/arch-linux.png" alt="Arch Linux" width="80">
</p>

<h1 align="center">Arch Linux</h1>

<p align="center">
  <strong>Dotfiles avec Hyprland, Waybar et Tabby</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Arch_Linux-1793D1?style=for-the-badge&logo=archlinux&logoColor=white" alt="Arch Linux">
  <img src="https://img.shields.io/badge/Hyprland-58E1FF?style=for-the-badge&logo=hyprland&logoColor=white" alt="Hyprland">
  <img src="https://img.shields.io/badge/Waybar-1a1b26?style=for-the-badge&logo=wayland&logoColor=white" alt="Waybar">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/VSCodium-2F80ED?style=for-the-badge&logo=vscodium&logoColor=white" alt="VSCodium">
  <img src="https://img.shields.io/badge/Tabby-FCD535?style=for-the-badge&logo=terminal&logoColor=black" alt="Tabby">
  <img src="https://img.shields.io/badge/Ollama-000000?style=for-the-badge&logo=ollama&logoColor=white" alt="Ollama">
  <img src="https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white" alt="Node.js">
  <img src="https://img.shields.io/badge/Rust-000000?style=for-the-badge&logo=rust&logoColor=white" alt="Rust">
</p>

<img src="../assets/fastfetch-arch.png" alt="Arch Linux" width="550">

<p align="center">
  <a href="https://archlinux.org/download/"><strong>Télécharger l'ISO</strong></a>
</p>

---

## Structure

```
arch-linux/
├── dotfiles/
│   ├── hypr/hyprland.conf
│   ├── waybar/
│   └── tabby/
└── scripts/install.sh
```

---

## Installation

### Prérequis

```bash
git clone https://aur.archlinux.org/paru.git
cd paru && makepkg -si
```

### Script automatique

```bash
cd arch-linux
chmod +x scripts/install.sh
./scripts/install.sh
```

Installe : Hyprland, Waybar, Tabby, VSCodium, Ollama, Rust, Node.js

---

## Configuration

### Hyprland

| Paramètre | Valeur |
|-----------|--------|
| Layout | dwindle |
| Gaps | 8px (in), 18px (out) |
| Workspaces | 5 (F1-F5) |

**Raccourcis** : `Super+Return` terminal · `Super+Tab` files · `Super+F` float

### Waybar

Modules : clock, workspaces, network, battery, memory, temperature

Theme : Catppuccin Mocha

### Tabby

Terminal avec profils et shortcuts personnalisés

---

## Paquets

| Catégorie | Paquets |
|-----------|---------|
| WM | hyprland, waybar |
| Terminal | tabby, kitty, zsh |
| Éditeurs | vscodium, neovim |
| Dev | nodejs, rust, cargo |
| IA | ollama |

---

---

## Ressources

[Arch Wiki](https://wiki.archlinux.org/) · [Hyprland Wiki](https://wiki.hyprland.org/)

---

<p align="center">
  Made by <a href="https://github.com/RomeoCavazza">Romeo Cavazza</a>
</p>
