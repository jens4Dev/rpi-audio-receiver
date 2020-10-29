#!/bin/bash -e

read -e -i "$(hostname)" -p "Hostname for the Pi: " -r HOSTNAME
sudo raspi-config nonint do_hostname "${HOSTNAME:-$(hostname)}"

CURRENT_PRETTY_HOSTNAME=$(hostnamectl status --pretty)
read -e -i "$CURRENT_PRETTY_HOSTNAME" -p "Pretty hostname used as visible device name (Bluetooth, AirPlay, ..): " -r PRETTY_HOSTNAME
sudo hostnamectl set-hostname --pretty "${PRETTY_HOSTNAME:-${CURRENT_PRETTY_HOSTNAME:-Raspberry Pi}}"

echo "Updating packages"
sudo apt update
sudo apt upgrade -y

echo "Installing components"
sudo ./install-bluetooth.sh
sudo ./install-shairport.sh
sudo ./install-spotify.sh
sudo ./install-upmpdcli.sh
sudo ./install-upnp.sh
sudo ./install-snapcast-client.sh
sudo ./install-pivumeter.sh
sudo ./enable-hifiberry.sh
sudo ./enable-read-only.sh

echo
echo "rpi-audio-receiver: Done!"