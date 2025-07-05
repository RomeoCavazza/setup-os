#!/bin/bash

set -e

echo "🔧 Installation des paquets AUR et principaux outils..."

paru -S --needed \
  vscodium \
  ollama \
  tabby \
  zsh \
  neovim \
  kitty \
  hyprland \
  waybar \
  swww \
  pywal \
  mako \
  electron \
  nodejs \
  npm \
  rust \
  cargo \
  obsidian \
  unzip \
  ttf-jetbrains-mono \
  ttf-iosevka-nerd \
  jq \
  fd \
  ripgrep \
  wget \
  curl

echo "🔁 Restauration des dotfiles..."
cp -r ../dotfiles/* ~/

echo "✅ Installation et configuration terminées."
