#!/bin/bash

# Update base packages
sudo dnf update

# Install Chrome
sudo dnf install chrome-stable -Y
sudo dnf install firefox -Y

# Install Libre office and copy registrymodifications.xcu
sudo dnf install libreoffice -Y
CONFIG_PATH="$HOME/.config/libreoffice/4/user"
mkdir -p "$CONFIG_PATH"
curl -o "$CONFIG_PATH/registrymodifications.xcu" "https://raw.githubusercontent.com/Through-the-Trees/setup-scripts/refs/heads/main/linux/libreoffice-config/registrymodifications.xcu"