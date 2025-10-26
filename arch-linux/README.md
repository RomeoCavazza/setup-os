# Arch Linux Dotfiles

![Arch Linux](https://img.shields.io/badge/Arch%20Linux-1793D1?logo=archlinux&logoColor=white)
![Hyprland](https://img.shields.io/badge/Hyprland-44586a?logo=hyprland&logoColor=white)
![Waybar](https://img.shields.io/badge/Waybar-1a1b1e?logo=waybar&logoColor=white)
![Tabby](https://img.shields.io/badge/Tabby-FCD535?logo=tabby&logoColor=black)
![VSCodium](https://img.shields.io/badge/VSCodium-0078D4?logo=vscode&logoColor=white)

Configuration Arch Linux avec Hyprland, Waybar, Tabby et dotfiles.

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

## 🔗 Télécharger l'ISO Arch Linux

📥 [https://archlinux.org/download/](https://archlinux.org/download/)

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

---

⭐ **Dotfiles minimalistes** — config clean
