#! /usr/bin/env bash

echo "Removing Brave Browser..."
sudo apt autoremove -y --purge brave-browser

echo "Installing software..."
flatpak install -y flathub com.google.Chrome
flatpak install -y flathub org.mozilla.firefox
flatpak install -y flathub org.videolan.VLC

# Apply configurations
echo "Configuring Libre Office..."
CONFIG_PATH="$HOME/.config/libreoffice/4/user"
mkdir -p "$CONFIG_PATH"
curl -o "$CONFIG_PATH/registrymodifications.xcu" "https://raw.githubusercontent.com/Through-the-Trees/setup-scripts/master/linux/libreoffice-config/registrymodifications.xcu"

# Set VLC as default for common media types
echo "Configuring VLC..."
xdg-mime default org.videolan.VLC.desktop video/mp4
xdg-mime default org.videolan.VLC.desktop video/x-matroska
xdg-mime default org.videolan.VLC.desktop video/x-msvideo
xdg-mime default org.videolan.VLC.desktop video/x-flv
xdg-mime default org.videolan.VLC.desktop audio/mpeg
xdg-mime default org.videolan.VLC.desktop audio/x-wav
xdg-mime default org.videolan.VLC.desktop audio/mp4
xdg-mime default org.videolan.VLC.desktop application/ogg

# Set firefox as default PDF & Browser
echo "setting default browser..."
xdg-settings set default-web-browser org.mozilla.firefox.desktop
xdg-mime default org.mozilla.firefox.desktop application/pdf

# Set power settings to keep screen on
echo "Adjusting power settings for shop display..."
gsettings set org.gnome.settings-daemon.plugins.power idle-dim false
gsettings set org.gnome.desktop.session idle-delay 0

# Pin apps to taskbar
echo "Pinning apps to taskbar..."
gsettings set org.gnome.shell favorite-apps "['org.mozilla.firefox.desktop', 'com.google.Chrome.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Software.desktop', 'libreoffice-startcenter.desktop']"

# Disable overlay and enable Zorin Menu for super key
echo "Changing super key behavior..."
gsettings set org.gnome.mutter overlay-key ''
gsettings set org.gnome.shell.extensions.zorin-menu super-hotkey true

# Battery %
gsettings set org.gnome.desktop.interface show-battery-percentage true

# Trackpad

# Test
read -n 1 -r -p "Does your laptop have buttons below the touchpad? [y/N] " key
if [[ $key =~ [yY] ]]; then
    echo "Disabling touch bottom-right to right click..."
    gsettings set org.gnome.desktop.peripherals.touchpad click-method 'fingers'
else
    echo "Enabling touch bottom-right to right click..."
    gsettings set org.gnome.desktop.peripherals.touchpad click-method 'area'
fi

# read -r -p "Does your maching have buttons under the touchpad? [y/n]: " answer
# if [[ "$answer" = "y" ]]; then
#     echo "Disabling touch bottom-right to right click..."
#     gsettings set org.gnome.desktop.peripherals.touchpad click-method 'fingers'
# else
#     echo "Enabling touch bottom-right to right click..."
#     gsettings set org.gnome.desktop.peripherals.touchpad click-method 'area'
# fi

read -n 1 -s -r -p "Press any key to continue..."
echo