#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update
sudo apt-get upgrade -y -o Dpkg::Options::="--force-confold"

curl -fsSL https://get.docker.com | sudo DEBIAN_FRONTEND=noninteractive sh

sudo usermod -aG docker $USER

echo "Downloading kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

rm kubectl

curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
