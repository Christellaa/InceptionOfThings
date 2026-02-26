#!/bin/bash

NODE_IP=$1

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--node-ip=${NODE_IP}" sh -