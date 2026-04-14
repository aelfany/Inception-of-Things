#!/bin/bash

cd ~/test/scripts/argo

git init

git config credential.helper ""
git config http.sslVerify false

git remote remove origin 2>/dev/null 
git remote add origin https://root:glpat -MASTER-TOKEN-2026-TOKEN@gitlab.192.168.56.112.gitlab/root/abelfany.git

git config user.email "you@example.com"
git config user.name "Your Name"

git branch -M main

git add .
git commit -m "Initial automated push" || true

echo "🚀 Pushing to local GitLab over HTTPS..."
git push -u origin main

kubectl apply -f ../confs/Application.yaml
kubectl apply -f ../confs/gitlab-repo-secret.yaml
