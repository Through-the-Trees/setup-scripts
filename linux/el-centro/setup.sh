#!/bin/bash

# Install Chrome
echo "Installing Google Chrome..."
sudo dnf install fedora-workstation-repositories -y
sudo dnf config-manager setopt google-chrome.enabled=1
sudo dnf install google-chrome-stable -y

# Install git (prerequisite for key re-mapping script)
echo "Installing git..."
sudo dnf install git-core -y

# Install Libre office and copy registrymodifications.xcu
# echo "Installing Libre Office..."
# sudo dnf install libreoffice -y
echo "Configuring Libre Office..."
CONFIG_PATH="$HOME/.config/libreoffice/4/user"
mkdir -p "$CONFIG_PATH"
curl -o "$CONFIG_PATH/registrymodifications.xcu" "https://raw.githubusercontent.com/Through-the-Trees/setup-scripts/refs/heads/main/linux/libreoffice-config/registrymodifications.xcu"

echo "Configuring KDE Desktop...."
# Disable window animations for performance optimization
kwriteconfig6 --key AnimationDurationFactor 0
# Pin apps to "Task Manager"
launcher_apps="applications:google-chrome.desktop,applications:org.mozilla.firefox.desktop,preferred://filemanager,applications:org.kde.discover.desktop"
kwriteconfig6 --file "$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc" --group "Containments" --group "2" --group "Applets" --group "5" --group "Configuration" --group "General" --key "launchers" "$launcher_apps"
# Set Background
path_to_wallpaper="/usr/share/wallpapers/Altai"
kwriteconfig6 --file "$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc" --group "Containments" --group "1" --group "Wallpaper" --group "org.kde.image" --group "General" --key "Image" "$path_to_wallpaper"

echo "Applying KDE Desktop configuration..."
systemctl --user restart plasma-plasmashell

# Rename device
read -p "Enter device asset tag: " asset
sudo hostnamectl set-hostname "TtT-$asset"
echo "Machine host name set to 'TtT-$asset'"

# Update base packages
# echo "Updating base packages..."
# sudo dnf update && sudno dnf upgrade