# Rocky Linux ISO

![Rocky Linux](https://img.shields.io/badge/Rocky%20Linux-10B981?logo=rockylinux&logoColor=white)
![GNOME](https://img.shields.io/badge/GNOME-4A86CF?logo=gnome&logoColor=white)

ISO **Rocky Linux 10** avec **GNOME Desktop** pour déploiement serveur et développement.

---

## 📁 Contenu

```
rocky-linux/
└── rocky-10-gnome.iso    # ISO Rocky Linux 10 GNOME
```

**Spécifications** :
- **Version** : Rocky Linux 10
- **Desktop** : GNOME
- **Architecture** : x86_64
- **Taille** : ~4.4GB

---

## 🚀 Créer une clé USB bootable

### macOS

```bash
diskutil list
diskutil unmountDisk /dev/disk2
sudo dd if=rocky-10-gnome.iso of=/dev/rdisk2 bs=1m
diskutil eject /dev/disk2
```

### Linux

```bash
lsblk
sudo umount /dev/sdb*
sudo dd if=rocky-10-gnome.iso of=/dev/sdb bs=4M status=progress
sync
```

### Windows

Utiliser [Rufus](https://rufus.ie/) ou [Etcher](https://etcher.balena.io/)

---

## 📋 Installation

1. Booter depuis USB
2. Sélectionner "Test this media and install Rocky Linux"
3. Configurer réseau (DHCP)
4. Sélectionner "GNOME Desktop + Development Tools"
5. Créer utilisateur + mot de passe
6. Installer (~15-20 min)

---

## 🛠️ Post-installation

### Mise à jour

```bash
sudo dnf update -y
```

### Paquets essentiels

```bash
sudo dnf install -y \
  vim git wget curl \
  htop btop neofetch \
  @development-tools
```

### RPM Fusion

```bash
sudo dnf install -y \
  https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm -E %rhel).noarch.rpm
```

### Docker

```bash
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io
sudo systemctl enable --now docker
sudo usermod -aG docker $USER
```

---

## 📚 Ressources

- [Rocky Linux Docs](https://docs.rockylinux.org/)
- [RPM Fusion](https://rpmfusion.org/)

---

⭐ **ISO stable** — Rocky Linux 10 GNOME pour serveurs
