# 🐧 Arch Linux Dotfiles

[![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793D1?style=for-the-badge&logo=archlinux&logoColor=white)](https://archlinux.org)
[![Hyprland](https://img.shields.io/badge/Hyprland-58E1FF?style=for-the-badge&logo=hyprland&logoColor=white)](https://hyprland.org)
[![Waybar](https://img.shields.io/badge/Waybar-1a1b26?style=for-the-badge&logo=wayland&logoColor=white)](https://github.com/Alexays/Waybar)

[![Tabby](https://img.shields.io/badge/Tabby-FCD535?style=flat-square&logo=terminal&logoColor=black)](https://tabby.sh)
[![VSCodium](https://img.shields.io/badge/VSCodium-2F80ED?style=flat-square&logo=vscodium&logoColor=white)](https://vscodium.com)
[![Ollama](https://img.shields.io/badge/Ollama-000000?style=flat-square&logo=ollama&logoColor=white)](https://ollama.ai)
[![Node.js](https://img.shields.io/badge/Node.js-339933?style=flat-square&logo=nodedotjs&logoColor=white)](https://nodejs.org)
[![Rust](https://img.shields.io/badge/Rust-000000?style=flat-square&logo=rust&logoColor=white)](https://rust-lang.org)

> Configuration Arch Linux avec Hyprland, Waybar, Tabby et dotfiles.

---

## 💿 Télécharger l'ISO

| Version | Téléchargement |
|---------|----------------|
| **Arch Linux** (rolling release) | [📥 archlinux.org/download](https://archlinux.org/download/) |

---

## 📁 Structure

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

## 🚀 Installation

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

## 🎨 Configuration

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

## 🔧 Paquets

- hyprland, waybar, tabby
- vscodium, ollama
- zsh, kitty, neovim
- nodejs, rust, cargo

---

## 📚 Ressources

- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Arch Wiki](https://wiki.archlinux.org/)
