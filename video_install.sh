#!/bin/bash

# Docker Installation
echo "🚀 Starting Docker installation..."
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-cache policy docker-ce
sudo apt install -y docker-ce
echo "✅ Docker installation completed!"

# Creating short-video data volume
echo "📂 Creating short-video data volume..."
cd ~
mkdir short_video_data
sudo chmod -R 755 short_video_data
echo "✅ short-video data volume is ready!"

# Docker Compose Setup
echo "🐳 Setting up Docker Compose..."
wget https://raw.githubusercontent.com/zero2launch/short_video_vps/main/compose.yaml -O compose.yaml
export EXTERNAL_IP=http://"$(hostname -I | cut -f1 -d' '):81"
sudo -E docker compose up -d
echo "🎉 Video service is live at: $EXTERNAL_IP"
