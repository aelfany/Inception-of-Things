#!/bin/bash

curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

kubectl create namespace gitlab --dry-run=client -o yaml | kubectl apply -f -

helm repo add gitlab https://charts.gitlab.io/
helm repo update

helm install gitlab gitlab/gitlab -n gitlab -f ../confs/gitlab-values.yaml --timeout 600s

echo ""
echo "⏳ Waiting for GitLab pods to spin up..."
sleep 15 

echo "This can take 5-10 minutes (Migrations take time). Please wait."

while true; do
    READY_PODS=$(kubectl get pods -n gitlab --no-headers | grep -v "Completed" | awk '{print $2}' | cut -d/ -f1 | awk '{s+=$1} END {print s}')
    TOTAL_PODS=$(kubectl get pods -n gitlab --no-headers | grep -v "Completed" | awk '{print $2}' | cut -d/ -f2 | awk '{s+=$1} END {print s}')
    
    WS_STATUS=$(kubectl get pods -n gitlab -l app=webservice --no-headers 2>/dev/null | awk '{print $3}' | head -n 1)

    if [[ "$READY_PODS" == "$TOTAL_PODS" && "$WS_STATUS" == "Running" ]]; then
        echo -e "\n✅ All pods are ready!"
        break
    else
        echo -n "."
        sleep 10
    fi
done

ROOT_PASSWORD=$(kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -o jsonpath="{.data.password}" | base64 --decode)

echo "$ROOT_PASSWORD" > git-pass.txt
echo "🔗 URL: http://gitlab.local"

kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -o jsonpath="{.data.password}" | base64 --decode > git-pass.txt