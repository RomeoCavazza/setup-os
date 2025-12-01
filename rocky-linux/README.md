# 🪨 Rocky Linux

[![Rocky Linux](https://img.shields.io/badge/Rocky_Linux_9-10B981?style=for-the-badge&logo=rockylinux&logoColor=white)](https://rockylinux.org)
[![GNOME](https://img.shields.io/badge/GNOME-4A86CF?style=for-the-badge&logo=gnome&logoColor=white)](https://gnome.org)
[![RHEL](https://img.shields.io/badge/RHEL_Compatible-EE0000?style=for-the-badge&logo=redhat&logoColor=white)](https://redhat.com)

[![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat-square&logo=docker&logoColor=white)](https://docker.com)
[![DNF](https://img.shields.io/badge/DNF-294172?style=flat-square&logo=fedora&logoColor=white)](https://dnf.readthedocs.io)
[![RPM Fusion](https://img.shields.io/badge/RPM_Fusion-1A5276?style=flat-square&logo=linux&logoColor=white)](https://rpmfusion.org)

> Distribution enterprise-grade basée sur RHEL, avec GNOME Desktop.

---

## 💿 Télécharger l'ISO

| Version | Téléchargement |
|---------|----------------|
| **Rocky Linux 9 GNOME** | [📥 rockylinux.org/download](https://rockylinux.org/download) |

---

## 📁 Contenu

```
rocky-linux/
└── README.md
```

**Spécifications** : Rocky Linux 9, GNOME, x86_64

---

## 🚀 Créer clé USB bootable

### macOS

```bash
diskutil list
diskutil unmountDisk /dev/disk2
sudo dd if=rocky-9-gnome.iso of=/dev/rdisk2 bs=1m
diskutil eject /dev/disk2
```

### Linux

```bash
lsblk
sudo umount /dev/sdb*
sudo dd if=rocky-9-gnome.iso of=/dev/sdb bs=4M status=progress
sync
```

### Windows

[Rufus](https://rufus.ie/) ou [Etcher](https://etcher.balena.io/)

---

## 📋 Installation

1. Booter depuis USB
2. "Test this media and install Rocky Linux"
3. Configurer réseau (DHCP)
4. "GNOME Desktop + Development Tools"
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
sudo dnf install -y vim git wget curl htop btop neofetch @development-tools
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
- [Ventoy](https://www.ventoy.net/en/download.html)
- [Rufus](https://rufus.ie/)
- [RPM Fusion](https://rpmfusion.org/)
