#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

message_Info() {
    local GREEN="\033[0;32m"
    local END="\033[0m"
    echo -e "${GREEN}$1${END}"
}

message_Info "--- Starting K3s Setup on Debian ---"

message_Info "Updating packages..."
sudo apt-get update && sudo apt-get upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"

if systemctl status k3s &>/dev/null; then
    message_Info "K3s is Already Downloaded ✅"
else
    message_Info "⬇️ Start Downloading k3s"
    curl -sfL https://get.k3s.io | sh -s - server \
    --bind-address=192.168.56.110 \
    --node-ip=192.168.56.110 \
    --write-kubeconfig-mode 644
    
    message_Info "Waiting for K3s to initialize..."
    sleep 20
fi

if sudo cat /var/lib/rancher/k3s/server/node-token > /vagrant/token.txt; then
    message_Info "✅ Server token saved to /vagrant/token.txt"
else
    message_Info "❌ Error: Failed to save server token"
    exit 1
fi

message_Info "--- Finish K3s Setup on Debian ---"