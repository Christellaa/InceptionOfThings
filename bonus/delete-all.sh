#!/bin/bash

k3d cluster delete --all
rm -rf ~/.kube
rm -rf gitlab-repo
rm kustomization.yaml