#!/bin/bash

GITLAB_DOMAIN=$(kubectl get ingress gitlab-webservice-default -n gitlab -o jsonpath='{.spec.rules[0].host}')
TOKEN=$(cat ~/Inception-of-Things/Bonus/scripts/token.txt)

grep -q "$GITLAB_DOMAIN" /etc/hosts || sudo sh -c "echo '127.0.0.1 $GITLAB_DOMAIN' >> /etc/hosts"

curl -LkH "PRIVATE-TOKEN: $TOKEN" \
     -H "Content-Type: application/json" \
     -d '{"name": "abelfany", "visibility": "public"}' \
     "http://$GITLAB_DOMAIN/api/v4/projects"