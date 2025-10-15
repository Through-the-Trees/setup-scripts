#!/bin/bash

# Update base packages
sudo apt update && sudo apt upgrade

# Install Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i ./google-chrome-stable_current_amd64.deb
sudo rm -f ./google-chrome-stable_current_amd64.deb

# Install Libre office and copy registrymodifications.xcu
sudo apt install libreoffice -Y
CONFIG_PATH="$HOME/.config/libreoffice/4/user"
mkdir -p "$CONFIG_PATH"
curl -o "$CONFIG_PATH/registrymodifications.xcu" "https://raw.githubusercontent.com/Through-the-Trees/setup-scripts/refs/heads/main/linux/libreoffice-config/registrymodifications.xcu"

# Disable window animations for performance optimization
kwriteconfig6 --key AnimationDurationFactor 0

# ~/.config/plasma-org.kde.plasma.desktop-appletsrc
# [Containments][2][Applets][5][Configuration][General]

# Keyboard setup
echo "
running cros-keyboard-map script by WeirdTreeThing...
(https://github.com/WeirdTreeThing/cros-keyboard-map)
"
git clone https://github.com/WeirdTreeThing/cros-keyboard-map ~/keyd-chromebook
sudo bash ~/keyd-chromebook/install.sh
rm -rf ~/keyd-chromebook