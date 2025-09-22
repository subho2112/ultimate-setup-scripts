#!/bin/bash
# =========================================
# Ultimate Linux Mint XFCE Customization Script
# =========================================

echo "Starting ultimate customization..."

# -----------------------
# Update system
# -----------------------
sudo apt update && sudo apt upgrade -y

# -----------------------
# Essential Dev Tools
# -----------------------
echo "Installing development tools..."
sudo apt install -y build-essential git curl wget python3 python3-pip nodejs npm openjdk-17-jdk golang ruby

# -----------------------
# Useful Utilities
# -----------------------
echo "Installing utilities..."

# Simple screen recorder
sudo apt install -y kazam

# USB formatting & recovery
sudo apt install -y gparted testdisk

# System monitoring
sudo apt install -y htop neofetch glances

# Timescale (Gufy Timescale alternative)
# https://docs.timescale.com/timescaledb/latest/how-to-guides/ubuntu-setup/
sudo apt install -y postgresql postgresql-contrib
sudo sh -c 'echo "deb https://packagecloud.io/timescale/timescaledb/ubuntu/ $(lsb_release -cs) main" > /etc/apt/sources.list.d/timescaledb.list'
wget --quiet -O - https://packagecloud.io/timescale/timescaledb/gpgkey | sudo apt-key add -
sudo apt update
sudo apt install -y timescaledb-2-postgresql-15
sudo timescaledb-tune

# Enable Flatpak & Flathub safely
sudo apt install -y flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# -----------------------
# Snap Removal
# -----------------------
echo "Removing Snap and disabling services..."
sudo snap remove --purge $(snap list | awk '{if(NR>1)print $1}')
sudo systemctl stop snapd.service snapd.socket
sudo systemctl disable snapd.service snapd.socket

# -----------------------
# XFCE Panel Customization
# -----------------------
echo "Configuring XFCE panel..."
xfconf-query -c xfce4-panel -p /panels/panel-1/position -s "p=0;x=0;y=0" # Move to top-left
xfconf-query -c xfce4-panel -p /panels/panel-1/length -s 100
xfce4-panel --restart

# Add centered clock
xfce4-panel --add=clock
xfce4-panel --restart

# -----------------------
# Wallpaper from Unsplash
# -----------------------
echo "Setting Unsplash wallpaper..."
wget -O /tmp/wallpaper.jpg "https://source.unsplash.com/random/1920x1080/?nature"
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-path -s "/tmp/wallpaper.jpg"

# -----------------------
# Autostart scripts
# -----------------------
mkdir -p ~/.config/autostart
cp src/autostart.sh ~/.config/autostart/
chmod +x ~/.config/autostart/autostart.sh

# -----------------------
# Cleanup
# -----------------------
echo "Cleaning up system..."
sudo apt autoremove -y
sudo apt autoclean -y

echo "Customization & utilities installation completed!"
echo "Please log out and log back in to see all changes."
