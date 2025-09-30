#!/bin/bash
# =========================================
# Ultimate KDE Neon Customization Script
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
sudo apt install -y simplescreenrecorder

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
sudo apt install -y flatpak plasma-discover-backend-flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# -----------------------
# Snap Removal
# -----------------------
echo "Removing Snap and disabling services..."
sudo snap remove --purge $(snap list | awk '{if(NR>1)print $1}')
sudo systemctl stop snapd.service snapd.socket
sudo systemctl disable snapd.service snapd.socket

# -----------------------
# KDE Plasma Customization
# -----------------------
echo "Configuring KDE Plasma desktop..."

# Install KDE tools
sudo apt install -y kde-spectacle plasma-discover plasma-workspace-wallpapers

# Apply dark theme
lookandfeeltool -a org.kde.breezedark.desktop

# Set wallpaper from Unsplash
echo "Setting Unsplash wallpaper..."
wget -O /tmp/wallpaper.jpg "https://source.unsplash.com/random/1920x1080/?nature"
plasma-apply-wallpaperimage /tmp/wallpaper.jpg

# Set some panel/dock tweaks (move panel to bottom, center task manager if Latte Dock installed)
# Move default panel to bottom
qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "
var allDesktops = desktops();
for (i=0;i<allDesktops.length;i++) {
  d = allDesktops[i];
  panels = d.panels();
  for (j=0;j<panels.length;j++) {
    p = panels[j];
    p.location = 'bottom';
  }
}
"

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
