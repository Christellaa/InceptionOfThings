#!/bin/bash

SERVER_NAME=$1

vagrant ssh $SERVER_NAME -c "sudo kubectl create configmap app-one-files --from-file=/websites/app1 \
&& sudo kubectl create configmap app-two-files --from-file=/websites/app2 \
&& sudo kubectl create configmap app-three-files --from-file=/websites/app3 \
&& sudo kubectl apply -f /confs/services.yml \
&& sudo kubectl apply -f /confs/deployments.yml \
&& sudo kubectl apply -f /confs/ingresses.yml"