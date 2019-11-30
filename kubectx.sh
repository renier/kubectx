#!/bin/bash
if [ "${1}" == "compgen" ]; then
    compgen=($(kubectl config get-contexts | sed -e '1d' | sed -e 's/^[* ]*//' | awk '{print $1}'))
    echo "${compgen[@]}"
    exit 0
fi

# set KUBECONFIG paths
KUBECONFIG=~/.kube/config
configs_array=($(find ~/.bluemix/plugins/container-service -name "*.yml" | xargs ls -1t))
configs=$(printf ":%s" "${configs_array[@]}")
KUBECONFIG="${KUBECONFIG}${configs}"
export KUBECONFIG
unset configs_array
unset configs

# set context from $1
if [ -n "${1}" ]; then
    kubectl config use-context "${1}"
fi

# set namespace from $2
if [ -n "${2}" ]; then
    kubectl config set-context --current --namespace="${2}"
fi

# show context map at the end
if [ $# -eq 0 ] || [ $# -eq 2 ]; then
    kubectl config get-contexts
fi
