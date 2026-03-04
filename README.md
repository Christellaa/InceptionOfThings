# InceptionOfThings

This project should be cloned in a Virtual Machine of your choice.

## Requirements
- Vagrant
- VirtualBox
- K3d
- Docker
- Kubectl
- ArgoCD CLI
- Helm
- Git
 
## p1
### Start a K3s cluster
```bash
cd p1
vagrant up
```

### Access the K3s cluster
You can either use SSH:
```bash
vagrant ssh cde-sous
```

## p2
### Start a K3s cluster
```bash
cd p1
vagrant up
```

### Access the K3s cluster
You can either use SSH:
```bash
vagrant ssh cde-sous
```
Or you can use a virtual machine manager.

### Steps to access the deployed websites
Add `192.168.56.110 app1.com`, `192.168.56.110 app2.com` and `192.168.56.110 app3.com` to your `/etc/hosts`.

Go to `app1.com`, `app2.com`, or `app3.com` to see the deployed websites.

Going to `localhost` redirects to `app3.com`.

## p3
1. In your terminal, run: ```./setup.sh```
2. Go to `localhost:8080` to go to ArgoCD UI
3. Go to `localhost` or `172.19.0.2` to go to the deployed website

## bonus
### Steps to run the project
1. Add `127.0.0.1 gitlab-gui.com` to your `/etc/hosts`
2. In your terminal, run: ```./setup.sh```
3. Go to `gitlab-gui.com` and create an empty repository
4. In the `update-repo-gitlab.sh` script, write the repository URL next to `GITLAB_REPO=`
5. Go back to `gitlab-gui.com` and create a Personal Access Token
6. Go back to the script and write the token next to `GITLAB_PAT=`
7. run `./update-repo-gitlab.sh`
8. Go to `localhost:8080` to go to ArgoCD UI
9. Go to `localhost` or `172.19.0.2` to go to the deployed website

### Using your own repository
If you plan to modify the Github repo of the website, write your own repo next to `--repo` in the `setup.sh` script:
```
argocd app create website \
  --repo https://github.com/Christellaa/argocd-pgimeno.git \
  --path ./confs \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace dev
```

Write it also in the `update-repo-gitlab.sh` script: ```git clone https://github.com/Christellaa/argocd-pgimeno.git github-repo```

1. Go to your own repository in your chosen Git hosting service.
2. Modify the image tag version in `deployments.yml` (example: ```image: christellaa/ci-cd-integration-img:v1``` where `v1` becomes `v2`), commit and push the changes
4. 'website' will be OutOfSync and 'website-gitlab' will automatically sync and show the changes
