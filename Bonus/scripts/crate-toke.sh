#!/bin/bash

TOOLBOX_POD=$(kubectl get pods -n gitlab -l app=toolbox -o jsonpath='{.items[0].metadata.name}')

kubectl exec -n gitlab -i $TOOLBOX_POD -- gitlab-rails runner "
user = User.find_by_username('root')

token = user.personal_access_tokens.find_by(name: 'argo-token')

if token.nil?
  token = user.personal_access_tokens.create!(
    name: 'argo-token',
    scopes: ['api', 'read_repository', 'write_repository'],
    expires_at: 1.year.from_now
  )
end

puts token.token
" > ~/test/scripts/token.txt