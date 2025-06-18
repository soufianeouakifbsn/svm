#!/bin/bash

# Stop Docker Compose
echo "🟢 Stopping Docker Compose..."
sudo -E docker compose down
echo "🔴 Docker Compose stopped."

# Setup Ngrok
echo "🟢 Setting up Ngrok..."
wget -O ngrok.tgz https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
sudo tar xvzf ./ngrok.tgz -C /usr/local/bin
sudo apt install -y jq

# Ngrok credentials (inserted directly)
token="2ydu6xnFE745us2CHwUkj3AAjUe_7QBXqRsTdNKYh76JJZfK2"
domain="talented-fleet-monkfish.ngrok-free.app"

# Configure and start Ngrok
ngrok config add-authtoken "$token"
ngrok http --domain="$domain" 3123 > /dev/null &

# Wait for Ngrok to initialize
echo "🔴🔴🔴 Waiting for Ngrok to initialize..."
sleep 8

# Fetch public URL from Ngrok
export EXTERNAL_IP="$(curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url')"
echo "Ngrok URL obtained: $EXTERNAL_IP"

echo "🔴 Ngrok setup complete."

# Start Docker Compose
echo "🟢 Starting Docker Compose..."
sudo -E docker compose up -d

echo "🔴 All done! Please wait a few minutes and then visit $EXTERNAL_IP to access the video UI."
