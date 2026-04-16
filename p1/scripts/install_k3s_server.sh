#!/bin/bash

sudo apt update -y
sudo apt upgrade -y curl

curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644 --node-ip 192.168.56.110

while [ ! -f /var/lib/rancher/k3s/server/node-token ]; do
    echo "Waiting for token file..."
    sleep 2
done

sudo cat /var/lib/rancher/k3s/server/node-token > /vagrant/token