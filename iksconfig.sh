#!/bin/bash
set -eo pipefail
cluster_name="$1"
ibmcloud ks cluster config --cluster "$cluster_name"
cluster_id=$(ibmcloud ks cluster get --cluster "$cluster_name" --json -s | grep '"id"' | cut -d '"' -f 4)
set --
kubectl config delete-context "${cluster_name}" > /dev/null 2>&1 || true
set -eo pipefail
kubectl config rename-context "${cluster_name}"/${cluster_id} "${cluster_name}"
kubectl config use-context "$cluster_name"
kubectl config set-context --current --namespace=default
