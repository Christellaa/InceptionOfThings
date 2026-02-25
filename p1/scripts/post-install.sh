#!/bin/bash

SERVER_NAME=$1
WORKER_NAME=$2

vagrant ssh $SERVER_NAME -c "sudo kubectl label node $WORKER_NAME node-role.kubernetes.io/worker=true"
