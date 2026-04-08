#!/bin/bash

# 1. Create the Cluster without Traefik
echo "Creating k3d cluster..."
sg docker -c "k3d cluster create my-gitops-cluster \
  -p '80:80@loadbalancer' \
  -p '443:443@loadbalancer' \
  --k3s-arg '--disable=traefik@server:*'"

# 2. Install NGINX Ingress Controller
echo "Installing NGINX Ingress Controller..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml

echo "Waiting for NGINX Ingress Controller to be ready..."
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s

# 3. Create Namespaces
kubectl create namespace argocd
kubectl create namespace dev

# 4. Install ArgoCD
echo "Installing ArgoCD..."
kubectl apply -n argocd --server-side -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml


echo "Waiting for all ArgoCD pods to be ready..."
while [[ $(kubectl get pods -n argocd --no-headers | grep -v "Running" | wc -l) -gt 0 ]] || \
      [[ $(kubectl get pods -n argocd --no-headers | awk '{print $2}' | grep -v "1/1" | wc -l) -gt 0 ]]; do
    echo -n "."
    sleep 2
done

# 5. Extract Password
echo -e "\nExtracting Admin Password..."
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d > password.txt

# 6. Install ArgoCD CLI (The Missing Piece)
echo "Installing ArgoCD CLI..."
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64

# 7. Apply the ArgoCD Ingress
# NOTE: Make sure you have your ingress YAML saved as 'argocd-ingress.yaml' in the same folder!
echo "Applying Ingress rules..."
kubectl apply -f argocd-ingress.yaml

# 8. Add local DNS resolution INSIDE the VM so the CLI can find the server
sudo sh -c "grep -q '127.0.0.1 argocd.local' /etc/hosts || echo '127.0.0.1 argocd.local' >> /etc/hosts"

# Give the Ingress a few seconds to route traffic
sleep 5

# 9. Login using the Domain Name (No port-forward needed!)
echo "Logging into ArgoCD CLI..."
argocd login argocd.local --username admin --password $(cat password.txt) --insecure

echo -e "\nSuccess! Everything is built, running, and authenticated!"