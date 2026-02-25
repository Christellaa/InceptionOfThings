#!/bin/bash

TYPE=$1
NODE_IP=$2
SERVER_IP=$3

if [ "$TYPE" = "server" ]; then
    curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--node-ip=${NODE_IP}" sh -
    sudo cat /var/lib/rancher/k3s/server/node-token > /vagrant/k3s-token
    sudo chmod 600 /vagrant/k3s-token
else
    while ! ping -c1 -W1 $SERVER_IP &> /dev/null; do
        sleep 2;
    done
    TOKEN_FILE="/vagrant/k3s-token"
    while [ ! -f "$TOKEN_FILE" ]; do sleep 1; done
    TOKEN=$(cat "$TOKEN_FILE")
    curl -sfL https://get.k3s.io | K3S_URL="https://$SERVER_IP:6443" K3S_TOKEN="$TOKEN" INSTALL_K3S_EXEC="--node-ip=${NODE_IP}" sh -
    rm -rf $TOKEN_FILE
fi
