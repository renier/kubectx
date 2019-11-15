#!/bin/bash
[ -z "${1}" ] && exit 1
ibmcloud ks cluster config "${1}"
cluster_id=$(ibmcloud ks cluster-get "${1}" --json -s | grep '"id"' | cut -d '"' -f 4)
cluster_name=${2:-$1}
kubectl config rename-context "${1}"/${cluster_id} "${cluster_name}"
