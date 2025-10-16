#!/bin/bash

# Install Chrome
# wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
# sudo dpkg -i ./google-chrome-stable_current_amd64.deb
# sudo rm -f ./google-chrome-stable_current_amd64.deb

# Install Chrome in Fedora
sudo dnf install fedora-workstation-repositories
sudo dnf config-manager setopt google-chrome.enabled=1
sudo dnf install google-chrome-stable

# Install Libre office and copy registrymodifications.xcu
sudo dnf install libreoffice -Y
CONFIG_PATH="$HOME/.config/libreoffice/4/user"
mkdir -p "$CONFIG_PATH"
curl -o "$CONFIG_PATH/registrymodifications.xcu" "https://raw.githubusercontent.com/Through-the-Trees/setup-scripts/refs/heads/main/linux/libreoffice-config/registrymodifications.xcu"

# ~/.config/plasma-org.kde.plasma.desktop-appletsrc
# [Containments][2][Applets][5][Configuration][General]

# Update base packages
sudo dnf update && sudno dnf upgrade