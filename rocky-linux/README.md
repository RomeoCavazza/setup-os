<p align="center">
  <img src="../assets/rocky.png" alt="Rocky Linux" width="80">
</p>

<h1 align="center">Rocky Linux</h1>

<p align="center">
  <strong>Distribution enterprise-grade basée sur RHEL</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Rocky_Linux_9-10B981?style=for-the-badge&logo=rockylinux&logoColor=white" alt="Rocky Linux">
  <img src="https://img.shields.io/badge/GNOME-4A86CF?style=for-the-badge&logo=gnome&logoColor=white" alt="GNOME">
  <img src="https://img.shields.io/badge/RHEL-EE0000?style=for-the-badge&logo=redhat&logoColor=white" alt="RHEL">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white" alt="Docker">
  <img src="https://img.shields.io/badge/DNF-294172?style=for-the-badge&logo=fedora&logoColor=white" alt="DNF">
  <img src="https://img.shields.io/badge/RPM_Fusion-1A5276?style=for-the-badge&logo=linux&logoColor=white" alt="RPM Fusion">
</p>

<img src="../assets/fastfetch-rocky.png" alt="Rocky Linux" width="550">

<p align="center">
  <a href="https://rockylinux.org/download"><strong>Télécharger l'ISO</strong></a>
</p>

---

## Structure

```
rocky-linux/
└── README.md
```

Spécifications : Rocky Linux 9, GNOME, x86_64

---

## Clé USB bootable

### Linux

```bash
lsblk
sudo umount /dev/sdb*
sudo dd if=rocky-9-gnome.iso of=/dev/sdb bs=4M status=progress
sync
```

### macOS

```bash
diskutil list
diskutil unmountDisk /dev/disk2
sudo dd if=rocky-9-gnome.iso of=/dev/rdisk2 bs=1m
diskutil eject /dev/disk2
```

### Windows

[Rufus](https://rufus.ie/) ou [Etcher](https://etcher.balena.io/)

---

## Installation

1. Booter depuis USB
2. Test this media and install Rocky Linux
3. Configurer réseau (DHCP)
4. GNOME Desktop + Development Tools
5. Créer utilisateur + mot de passe
6. Installer (~15-20 min)

---

## Post-installation

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

---

## Ressources

[Rocky Docs](https://docs.rockylinux.org/) · [RPM Fusion](https://rpmfusion.org/) · [Ventoy](https://www.ventoy.net/)

---

<p align="center">
  Made by <a href="https://github.com/RomeoCavazza">Romeo Cavazza</a>
</p>
