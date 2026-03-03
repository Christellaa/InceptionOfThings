#!/bin/bash

# To do manually in GitLab UI:
# - Create a Gitlab repo
# - Replace <YOUR_GITLAB_REPO_URL_HERE> with the actual repo URL (e.g., http://gitlab-test.com:8181/root/test.git)
# - Create a Gitlab PAT with api and repo scopes
# - Replace <YOUR_GITLAB_PAT_HERE> with the actual PAT value

GITLAB_PWD=$(kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -o jsonpath="{.data.password}" | base64 -d)
GITLAB_REPO=<YOUR_GITLAB_REPO_URL_HERE>
GITLAB_URL=gitlab-test.com:8181/$GITLAB_REPO
GITLAB_SVC=http://gitlab-webservice-default.gitlab.svc:8181
GITLAB_PAT=<YOUR_GITLAB_PAT_HERE>

git clone http://$GITLAB_URL gitlab-repo

git clone https://github.com/Christellaa/argocd-pgimeno.git github-repo

mv github-repo/confs/* gitlab-repo/
rm -rf github-repo

cd gitlab-repo
echo "apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - deployments.yml
  - services.yml
  - ingresses.yml

namePrefix: gitlab-" > kustomization.yaml

git add .
git commit -m "Update manifests"
git remote set-url origin http://root:$GITLAB_PAT@$GITLAB_URL
git push

argocd app create website-gitlab \
  --repo $GITLAB_SVC/$GITLAB_REPO \
  --path . \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace dev \
  --sync-policy automated \
  --upsert
