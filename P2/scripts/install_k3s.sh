#!/bin/bash

curl -sfL https://get.k3s.io | sh -
sleep 10
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
kubectl apply -f /vagrant/confs/
