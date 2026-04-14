#!/bin/bash

sg docker -c "k3d cluster create my-gitops-cluster \
  -p '80:80@loadbalancer' \
  -p '443:443@loadbalancer' \
  --k3s-arg '--disable=traefik@server:*'"

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml

kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s

kubectl create namespace argocd
kubectl create namespace dev

kubectl apply -n argocd --server-side -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml


while [[ $(kubectl get pods -n argocd --no-headers | grep -v "Running" | wc -l) -gt 0 ]] || \
      [[ $(kubectl get pods -n argocd --no-headers | awk '{print $2}' | grep -v "1/1" | wc -l) -gt 0 ]]; do
    echo -n "."
    sleep 2
done

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d > password.txt

curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64

kubectl apply -f ../confs/argocd-ingress.yaml


echo -e "\nSuccess! Everything is built, running, and authenticated!"