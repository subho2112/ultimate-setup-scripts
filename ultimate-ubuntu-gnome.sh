#!/bin/bash
# =========================================
# Ultimate Ubuntu GNOME Customization Script
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

# TimescaleDB
sudo apt install -y postgresql postgresql-contrib
sudo sh -c 'echo "deb https://packagecloud.io/timescale/timescaledb/ubuntu/ $(lsb_release -cs) main" > /etc/apt/sources.list.d/timescaledb.list'
wget --quiet -O - https://packagecloud.io/timescale/timescaledb/gpgkey | sudo apt-key add -
sudo apt update
sudo apt install -y timescaledb-2-postgresql-15
sudo timescaledb-tune

# Enable Flatpak & Flathub safely
sudo apt install -y flatpak gnome-software-plugin-flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# -----------------------
# Snap Removal
# -----------------------
echo "Removing Snap and disabling services..."
sudo snap remove --purge $(snap list | awk '{if(NR>1)print $1}')
sudo systemctl stop snapd.service snapd.socket
sudo systemctl disable snapd.service snapd.socket

# -----------------------
# GNOME Customization
# -----------------------
echo "Configuring GNOME desktop..."

# Install GNOME Tweaks & Extensions
sudo apt install -y gnome-tweaks gnome-shell-extensions

# Top bar clock to center (via extension)
gnome-extensions enable ubuntu-dock@ubuntu.com || true
gnome-extensions enable datetime@gnome-shell-extensions.gcampax.github.com || true

# Set dark mode
gsettings set org.gnome.desktop.interface gtk-theme "Yaru-dark"

# Wallpaper from Unsplash
echo "Setting Unsplash wallpaper..."
wget -O /tmp/wallpaper.jpg "https://source.unsplash.com/random/1920x1080/?nature"
gsettings set org.gnome.desktop.background picture-uri "file:///tmp/wallpaper.jpg"
gsettings set org.gnome.desktop.background picture-uri-dark "file:///tmp/wallpaper.jpg"

# Favorite apps on Dock
gsettings set org.gnome.shell favorite-apps "['firefox.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.Nautilus.desktop', 'code.desktop']"

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
