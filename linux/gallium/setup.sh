#! /usr/bin/env bash

# Check Wi-Fi connection status
if nmcli -g STATE g == enabled; then
    if ! (nmcli -t -f ACTIVE,SSID dev wifi | grep -q "^yes"); then
        echo "Connect to wifi before running script."
        exit 1
    fi
else
    echo "Connect to wifi before running script."
    exit 1
fi

sudo add-apt-repository ppa:appgrid/stable
sudo apt update -Y && apt upgrade -Y && apt autoremove -Y
cd ~/Downloads && wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo apt install -f
sudo apt install firefox libreoffice vlc

# Apply configurations

# Libre Office default file formats
LIBRE_CONF_URL = "raw.githubusercontent.com/Through-the-Trees/setup-scripts/refs/heads/main/software/registrymodifications.xcu"
CONFIG_PATH="$HOME/.config/libreoffice/4/user"
mkdir -p "$CONFIG_PATH"
cd $CONFIG_PATH && curl $LIBRE_CONF_URL

# Set firefox as default PDF & Browser
xdg-settings set default-web-browser org.google.chrome.desktop
xdg-mime default org.mozilla.firefox.desktop application/pdf

echo "All Done"