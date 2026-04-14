TOOLBOX_POD=$(kubectl get pods -n gitlab -l app=toolbox -o jsonpath='{.items[0].metadata.name}')

kubectl exec -n gitlab -i $TOOLBOX_POD -- gitlab-rails runner "
token = User.find_by_username('root').personal_access_tokens.find_or_initialize_by(name: 'argo-token')
token.scopes = ['api', 'read_repository', 'write_repository']
token.expires_at = 1.year.from_now
token.set_token('glpat-MASTER-TOKEN-2026-TOKEN')
token.save!"

export GITLAB_TOKEN="glpat-MASTER-TOKEN-2026-TOKEN"