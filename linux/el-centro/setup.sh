#!/bin/bash

# Disable window animations for performance optimization
kwriteconfig6 --key AnimationDurationFactor 0

# Install Chrome in Fedora
echo "Installing Google Chrome..."
sudo dnf install fedora-workstation-repositories -y
sudo dnf config-manager setopt google-chrome.enabled=1
sudo dnf install google-chrome-stable -y

# Install Libre office and copy registrymodifications.xcu
echo "Installing Libre Office..."
sudo dnf install libreoffice -y
echo "Configuring Libre Office..."
CONFIG_PATH="$HOME/.config/libreoffice/4/user"
mkdir -p "$CONFIG_PATH"
curl -o "$CONFIG_PATH/registrymodifications.xcu" "https://raw.githubusercontent.com/Through-the-Trees/setup-scripts/refs/heads/main/linux/libreoffice-config/registrymodifications.xcu"

# ~/.config/plasma-org.kde.plasma.desktop-appletsrc
# [Containments][2][Applets][5][Configuration][General]

# Background
path_to_wallpaper='/usr/share/wallpapers/Altai'                  # The path to the wallpaper.
kwriteconfig5 --file "$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc" --group 'Containments' --group '1' --group 'Wallpaper' --group 'org.kde.image' --group 'General' --key 'Image' "$path_to_wallpaper"

# Rename device
read -p "Enter device asset tag: " asset
sudo hostnamectl set-hostname 'TtT-$asset'

# Update base packages
# echo "Updating base packages..."
# sudo dnf update && sudno dnf upgrade