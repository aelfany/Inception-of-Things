#!/bin/bash

sg docker -c "k3d cluster create mycluster"

kubectl create namespace argocd
kubectl create namespace dev

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "Waiting for all ArgoCD pods to be 1/1 Running..."

while [[ $(kubectl get pods -n argocd --no-headers | grep -v "Running" | wc -l) -gt 0 ]] || \
      [[ $(kubectl get pods -n argocd --no-headers | awk '{print $2}' | grep -v "1/1" | wc -l) -gt 0 ]]; do
    echo -n "."
    sleep 2
done

echo -e "\nAll pods are ready!"