#!/bin/bash

set -e

DOMAIN=$(kubectl get ingress gitlab-webservice-default -n gitlab -o jsonpath='{.spec.rules[0].host}')
TOKEN=$(tail -n 1 ~/Inception-of-Things/Bonus/scripts/token.txt | tr -d '\n')

REPO="root/abelfany.git"

cd ~/Inception-of-Things/Bonus/confs/dev

git config --global http.sslVerify false

if [ ! -d ".git" ]; then
  git init
  git config user.email "abd@example.com"
  git config user.name "Abdellatif"
  git branch -M main
  git remote add origin "https://oauth2:${TOKEN}@${DOMAIN}/${REPO}"
else
  git remote set-url origin "https://oauth2:${TOKEN}@${DOMAIN}/${REPO}"
fi

git add .
git diff --cached --quiet || git commit -m "update"
git push -u origin main