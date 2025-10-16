#!/bin/bash

# Disable window animations for performance optimization
kwriteconfig6 --key AnimationDurationFactor 0

# Install Chrome in Fedora
echo "Installing Google Chrome..."
sudo dnf install fedora-workstation-repositories -Y
sudo dnf config-manager setopt google-chrome.enabled=1
sudo dnf install google-chrome-stable -Y

# Install Libre office and copy registrymodifications.xcu
echo "Installing Libre Office..."
sudo dnf install libreoffice -Y
echo "Configuring Libre Office..."
CONFIG_PATH="$HOME/.config/libreoffice/4/user"
mkdir -p "$CONFIG_PATH"
curl -o "$CONFIG_PATH/registrymodifications.xcu" "https://raw.githubusercontent.com/Through-the-Trees/setup-scripts/refs/heads/main/linux/libreoffice-config/registrymodifications.xcu"

# ~/.config/plasma-org.kde.plasma.desktop-appletsrc
# [Containments][2][Applets][5][Configuration][General]

# Background
path_to_wallpaper = '/usr/share/wallpapers/Altai'                            # The path to the wallpaper.
kwriteconfig5                                                    \ # The configuration tool.
  --file "$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc" \ # The path to the configuration file.
    --group 'Containments'                                       \
      --group '1'                                                \
        --group 'Wallpaper'                                      \ # This can, alternatively, be a colour.
          --group 'org.kde.image'                                \
            --group 'General'                                    \
              --key 'Image' "$path_to_wallpaper"                   # The key which contains the path to the wallpaper.

# Rename device
read -p "Enter device asset tag: " asset
sudo hostnamectl set-hostname 'TtT-$asset'

# Update base packages
# echo "Updating base packages..."
# sudo dnf update && sudno dnf upgrade