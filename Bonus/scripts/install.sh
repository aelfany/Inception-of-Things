#!/bin/bash

sudo apt-get update

sudo DEBIAN_FRONTEND=noninteractive NEEDRESTART_MODE=a apt-get upgrade -y

curl -fsSL https://get.docker.com | sudo sh

sudo usermod -aG docker $USER

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

rm kubectl

curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
    
#test for push
echo "Installation complete! Reloading shell so Docker works without sudo..."