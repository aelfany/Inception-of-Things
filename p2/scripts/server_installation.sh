#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo apt-get install net-tools -y
sudo apt-get install -y curl

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--node-ip=192.168.56.110 --advertise-address=192.168.56.110 --write-kubeconfig-mode 644" sh -s -
    
echo "alias k='kubectl'" >> /home/vagrant/.bashrc

echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> /home/vagrant/.bashrc

kubectl apply -f /vagrant/confs
