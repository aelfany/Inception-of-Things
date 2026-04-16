#!/bin/bash

sudo apt update -y
sudo apt upgrade -y

NODE_IP="192.168.56.111"

while [ ! -f /vagrant/token ]; do
    echo "Still waiting for token..."
    sleep 2
done

K3S_TOKEN=$(cat /vagrant/token)

curl -sfL https://get.k3s.io | K3S_URL="https://192.168.56.110:6443" K3S_TOKEN="$K3S_TOKEN" sh -s - --node-ip $NODE_IP