#!/bin/bash

sudo apt update
sudo apt upgrade

yes | sudo apt install git-all

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb


sudo git clone https://github.com/Lioncat6/remap-util /chromebook-keys-remap
cd /chromebook-keys-remap
sudo bash remap-util.sh
sudo rm -rf /chromebook-keys-remap
