# Arch Linux Dotfiles

![Arch Linux](https://img.shields.io/badge/Arch%20Linux-1793D1?logo=archlinux&logoColor=white)
![Hyprland](https://img.shields.io/badge/Hyprland-44586a?logo=hyprland&logoColor=white)
![Waybar](https://img.shields.io/badge/Waybar-1a1b1e?logo=waybar&logoColor=white)
![Tabby](https://img.shields.io/badge/Tabby-FCD535?logo=tabby&logoColor=black)
![VSCodium](https://img.shields.io/badge/VSCodium-0078D4?logo=vscode&logoColor=white)
![Rust](https://img.shields.io/badge/Rust-000000?logo=rust&logoColor=white)

Configuration Arch Linux avec **Hyprland** (tiling manager), **Waybar**, **Tabby** et dotfiles pour environnement de développement productif.

---

## 📁 Structure

```
arch-linux/
├── dotfiles/
│   ├── hypr/
│   │   └── hyprland.conf          # Configuration Hyprland
│   ├── waybar/
│   │   ├── config.jsonc           # Configuration Waybar
│   │   └── style.css              # Styles Waybar
│   └── tabby/
│       ├── config.yaml            # Configuration Tabby
│       ├── config.yaml.backup
│       └── settings.json          # Settings Tabby
└── scripts/
    └── install.sh                 # Script d'installation automatique AUR
```

---

## 🚀 Installation

### Prérequis

Arch Linux installé avec **paru** (AUR helper).

```bash
# Installer paru si pas déjà fait
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
```

### Installation automatique

```bash
cd arch-linux
chmod +x scripts/install.sh
./scripts/install.sh
```

Le script installe :
- **Paquets AUR** : vscodium, ollama, tabby, obsidian
- **Hyprland stack** : hyprland, waybar, swww, pywal, mako
- **Terminals** : zsh, kitty, neovim, tabby
- **Toolchains** : nodejs, npm, rust, cargo
- **Polices** : ttf-jetbrains-mono, ttf-iosevka-nerd
- **Utils** : jq, fd, ripgrep, wget, curl, electron

Puis copie les dotfiles dans `~/`.

---

## 🎨 Configuration Hyprland

### Caractéristiques

- **Layout** : dwindle (arbres binaires)
- **Gaps** : 8px (in), 18px (out) dynamiques
- **Animations** : fade, border, layers (1, 3, default)
- **Borders** : 2px, rounding 10px
- **5 Workspaces** : F1-F5

### Raccourcis clavier

| Touche | Action |
|--------|--------|
| `Super + Return` | Terminal tiled (Foot) |
| `Super + A` | Terminal floating (Foot) |
| `Super + F` | Float/Tile toggle |
| `Super + Tab` | Gestionnaire fichiers (Nemo) |
| `Super + BackSpace` | Fermer toutes fenêtres |
| `Super + &` | Menu (Rofi type-7) |
| `Super + É` | Show workspaces |
| `Super + "` | nwggrid |
| `Super + '` | Historique clip (cliphist) |
| `Super + (` | System dashboard |

**Workspaces** : `Super + F1..F5` (switch), `Super + Shift + F1..F5` (move)

### Window Rules

```conf
# Float certains apps
windowrulev2 = float, class:^(Alacritty|pavucontrol|blueman)$

# Centrer fenêtres flottantes
windowrulev2 = center, floating:1

# Opacité custom
windowrulev2 = opacity 0.85, title:^(cmatrix|btop|yazi)$
```

**Fichier** : `dotfiles/hypr/hyprland.conf`

---

## 🎛️ Waybar

Barre d'état moderne avec modules :

### Modules actifs

- **Clock** : date + heure formatée
- **Workspaces** : 5 actifs/inactifs
- **Battery** : niveau + état charge
- **Network** : wifi/ethernet
- **Memory** : RAM utilisée
- **Temperature** : CPU
- **PulseAudio** : volume + icône

### Theme

Couleurs Catppuccin Mocha configurées dans `style.css`.

**Fichiers** : `dotfiles/waybar/config.jsonc`, `style.css`

---

## 💻 Tabby Terminal

Configuration terminal professionnelle avec :

- **Profils** : starship, oh-my-posh
- **Shortcuts** : tabs, splits, panes
- **Plugins** : search, save output, history

**Fichiers** : `dotfiles/tabby/config.yaml`, `settings.json`

---

## 🔧 Paquets installés

### Desktop & Tiling

- **hyprland** : Tiling window manager
- **waybar** : Barre d'état modulaire
- **swww** : Dynamic wallpapers
- **pywal** : Color schemes
- **mako** : Notifications

### Terminals & Shells

- **kitty** : Terminal GPU-accelerated
- **foot** : Terminal minimal
- **tabby** : Terminal moderne
- **zsh** : Shell avancé
- **neovim** : Éditeur modal

### File Managers & Utils

- **nemo** : Gestionnaire fichiers GTK
- **networkmanagerapplet** : Network manager GUI
- **pavucontrol** : Contrôle audio
- **blueman** : Bluetooth manager

### Dev Tools

- **vscodium** : Éditeur open-source
- **ollama** : IA locale
- **nodejs, npm** : JavaScript runtime
- **rust, cargo** : Rust toolchain
- **obsidian** : Notes markdown

### Fonts

- **ttf-jetbrains-mono** : Monospace
- **ttf-iosevka-nerd** : Dev icons

---

## 🔧 Personnalisation

### Changer le thème

```bash
# Avec pywal
wal -i ~/Images/wallpaper.png

# Ou éditer manuellement
vim ~/.config/waybar/style.css
```

### Ajouter modules Waybar

Éditer `~/.config/waybar/config.jsonc` :

```json
{
  "modules-left": ["clock", "workspaces"],
  "modules-center": ["custom/weather"],
  "modules-right": ["network", "battery"]
}
```

### Scripts custom Hyprland

Créer dans `~/.config/hypr/scripts/` :

```bash
#!/bin/bash
# Exemple : toggle_tiling.sh

hyprctl dispatch togglesplit
```

Ajouter dans `hyprland.conf` :

```conf
bind = SUPER, t, exec, ~/.config/hypr/scripts/toggle_tiling.sh
```

---

## 🐛 Dépannage

### Waybar ne démarre pas

```bash
# Check logs
journalctl -u waybar -b

# Relancer manuellement
waybar &
```

### Hyprland crash au login

Vérifier permissions fichiers :

```bash
chmod +x ~/.config/hypr/autostart_all.sh
```

### Tabby n'ouvre pas

```bash
# Vérifier config
cat ~/.config/tabby/config.yaml

# Relancer
tabby
```

### Paquets AUR ne s'installent pas

```bash
# Mettre à jour paru
paru -Syu

# Réinstaller
paru -S --needed <package>
```

---

## 📚 Ressources

- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Waybar GitHub](https://github.com/Alexays/Waybar)
- [Arch Wiki](https://wiki.archlinux.org/)
- [AUR Packages](https://aur.archlinux.org/)

---

⭐ **Dotfiles minimalistes** — config clean et productive pour Arch Linux
