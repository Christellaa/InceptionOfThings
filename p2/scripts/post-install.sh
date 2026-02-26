#!/bin/bash

SERVER_NAME=$1

vagrant ssh $SERVER_NAME -c "sudo kubectl apply -f /confs/services.yml \
&& sudo kubectl apply -f /confs/deployments.yml \
&& sudo kubectl apply -f /confs/ingresses.yml"