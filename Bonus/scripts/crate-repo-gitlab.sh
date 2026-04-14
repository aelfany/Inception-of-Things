 sudo sh -c "echo '127.0.0.1 gitlab.192.168.56.112.gitlab' >> /etc/hosts" 

 curl --insecure -L --header "PRIVATE-TOKEN: glpat-MASTER-TOKEN-2026-TOKEN" \
     --header "Content-Type: application/json" \
     --request POST \
     --data '{"name": "abelfany", "visibility": "public"}' \
     "http://gitlab.192.168.56.112.gitlab/api/v4/projects"