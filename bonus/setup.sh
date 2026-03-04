#!/bin/bash

k3d cluster create argo -p "80:80@loadbalancer" \
                        -p "443:443@loadbalancer"

kubectl create ns argocd
kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl wait --for=condition=Ready pod -n argocd --all --timeout=300s
kubectl port-forward svc/argocd-server -n argocd 8080:443 &>/dev/null &

ARGO_PWD=$(kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d)
argocd login localhost:8080 --username admin --password "$ARGO_PWD" --insecure

kubectl create namespace dev

kubectl create namespace gitlab
helm repo add gitlab http://charts.gitlab.io/
helm repo update
helm install gitlab gitlab/gitlab \
  --set global.hosts.domain=gitlab-test.com \
  --set global.hosts.externalIP=0.0.0.0 \
  --set global.hosts.https=false \
  --set certmanager-issuer.email=test@example.com \
  --set global.registry.install=false \
  --set gitlab-runner.install=false \
  --set prometheus.install=false \
  --set grafana.install=false \
  --set global.ingress.enabled=false \
  -n gitlab


kubectl wait --for=condition=ready --timeout=1200s pod -l app=webservice -n gitlab
GITLAB_PWD=$(kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -o jsonpath="{.data.password}" | base64 -d)

kubectl apply -f ./confs/gitlab-ingress.yml -n gitlab

argocd app create website \
  --repo https://github.com/Christellaa/argocd-pgimeno.git \
  --path ./confs \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace dev

argocd app sync website

echo "Access the website with http://172.19.0.2/ or localhost"
echo "Access ArgoCD UI with http://localhost:8080/ (username: admin, password: $ARGO_PWD)"
echo "Access GitLab UI with http://gitlab-gui.com/ (username: root, password: $GITLAB_PWD)"
