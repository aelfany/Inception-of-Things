#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

Error() {
    local RED="\033[0;31m"
    local END="\033[0m"
    echo -e "${RED}$1${END}"
}

message_Info() {
    local GREEN="\033[0;32m"
    local END="\033[0m"
    echo -e "${GREEN}$1${END}"
}

message_Info "--- Starting K3s Agent Setup on Ubuntu ---"

message_Info "Updating packages..."
sudo apt-get update -y && sudo apt-get upgrade -y 

if sudo swapon --show | grep -q '^'; then
    message_Info "Disabling swap..."
    sudo swapoff -a
    sudo sed -i '/ swap / s/^/#/' /etc/fstab
fi

if [ -f "/usr/local/bin/k3s" ]; then
    message_Info "K3s is Already Installed"
else
    message_Info "Start Downloading K3s Agent"

    while [ ! -f /vagrant/token.txt ]; do
        message_Info "Waiting for /vagrant/token.txt from master server..."
        sleep 5
    done

    TOKEN=$(cat /vagrant/token.txt)

    if [ -z "$TOKEN" ]; then
        Error "ERROR: Token is empty!"
        exit 1
    fi

    message_Info "------------ Token Found ------------"

    curl -sfL https://get.k3s.io | K3S_URL=https://192.168.56.110:6443 K3S_TOKEN=$TOKEN sh -

    message_Info "K3s Agent Installation Completed"
fi