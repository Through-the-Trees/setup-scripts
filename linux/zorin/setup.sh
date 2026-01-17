#! /usr/bin/env bash

echo "Removing Brave Browser..."
sudo apt autoremove -y --purge brave-browser

echo "Installing software..."
flatpak install -y flathub com.google.Chrome
flatpak install -y flathub org.mozilla.firefox
flatpak install -y flathub org.videolan.VLC
# Install gaming-specific software if flag set
if [[ "$1" == "-gaming" ]]; then
    flatpak install -y flathub com.valvesoftware.Steam
    flatpak install -y flathub com.geeks3d.furmark
fi

# Apply configurations
echo "Configuring Libre Office..."
CONFIG_PATH="$HOME/.config/libreoffice/4/user"
mkdir -p "$CONFIG_PATH"
curl -o "$CONFIG_PATH/registrymodifications.xcu" "https://raw.githubusercontent.com/Through-the-Trees/setup-scripts/master/libreoffice-config/registrymodifications.xcu"

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

echo "Configuring GNOME..."
# Set power settings to keep screen on
gsettings set org.gnome.settings-daemon.plugins.power idle-dim false
gsettings set org.gnome.desktop.session idle-delay 0
# Pin apps to taskbar
gsettings set org.gnome.shell favorite-apps "['org.mozilla.firefox.desktop', 'com.google.Chrome.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Software.desktop', 'libreoffice-startcenter.desktop', 'libreoffice-writer.desktop', 'libreoffice-impress.desktop', 'libreoffice-calc.desktop']"
# Disable overlay and enable Zorin Menu for super key
echo "Changing super key behavior..."
# gsettings set org.gnome.mutter overlay-key ''
gsettings set org.gnome.shell.extensions.zorin-menu super-hotkey true
# Battery %
gsettings set org.gnome.desktop.interface show-battery-percentage true
# Trackpad
read -n 1 -r -p "Does your laptop have separate buttons below the touchpad? [y/N] " key
if [[ $key =~ [yY] ]]; then
    echo -e "\nDisabling touch bottom-right to right click..."
    gsettings set org.gnome.desktop.peripherals.touchpad click-method 'fingers'
else
    echo -e "\nEnabling touch bottom-right to right click..."
    gsettings set org.gnome.desktop.peripherals.touchpad click-method 'areas'
fi

read -n 1 -s -r -p "Press any key to continue..."
echo
