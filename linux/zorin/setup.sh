#! /usr/bin/env bash

# Check Wi-Fi connection status
if nmcli -t -f WIFI g | grep -q "enabled"; then
    if ! (nmcli -t -f ACTIVE,SSID dev wifi | grep -q "^yes"); then
        echo "Connect to wifi before running script."
        exit 1
    fi
else
    echo "Connect to wifi before running script."
    exit 1
fi

# sudo apt autoremove -y --purge brave-browser

flatpak install -y flathub com.google.Chrome

flatpak install -y flathub org.mozilla.firefox

flatpak install -y flathub org.videolan.VLC

# Apply configurations

# Libre Office default file formats
USB_PATH=$(findmnt -n -o TARGET --target \
	"$(sudo find /media/* -type d -name '\$OEM\$' -print -quit)")
CONFIG_PATH="$HOME/.config/libreoffice/4/user"
mkdir -p "$CONFIG_PATH"
cp "$USB_PATH/\$OEM\$/\$1/TtT Setup/registrymodifications.xcu" "$CONFIG_PATH/registrymodifications.xcu"

# Set VLC as default for common media types
xdg-mime default org.videolan.VLC.desktop video/mp4
xdg-mime default org.videolan.VLC.desktop video/x-matroska
xdg-mime default org.videolan.VLC.desktop video/x-msvideo
xdg-mime default org.videolan.VLC.desktop video/x-flv
xdg-mime default org.videolan.VLC.desktop audio/mpeg
xdg-mime default org.videolan.VLC.desktop audio/x-wav
xdg-mime default org.videolan.VLC.desktop audio/mp4
xdg-mime default org.videolan.VLC.desktop application/ogg

# Set firefox as default PDF & Browser
xdg-settings set default-web-browser org.mozilla.firefox.desktop
xdg-mime default org.mozilla.firefox.desktop application/pdf

# Set power settings to keep screen on
gsettings set org.gnome.settings-daemon.plugins.power idle-dim false
gsettings set org.gnome.desktop.session idle-delay 0
