#!/bin/bash

sudo apt update -Y && apt upgrade -Y && apt autoremove -Y

yes | sudo apt install git-all

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb


sudo git clone https://github.com/Lioncat6/remap-util /chromebook-keys-remap
cd /chromebook-keys-remap
sudo bash remap-util.sh
sudo rm -rf /chromebook-keys-remap

sudo apt install libreoffice
CONFIG_PATH="$HOME/.config/libreoffice/4/user"
mkdir -p "$CONFIG_PATH"

curl -o "$CONFIG_PATH/registrymodifications.xcu" "https://raw.githubusercontent.com/Through-the-Trees/setup-scripts/refs/heads/main/linux/libreoffice-config/registrymodifications.xcu"