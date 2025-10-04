#! usr/bin/env bash

sudo dmidecode -s system-serial-number
read -n 1 -s -r -p "Press any key to continue..."