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
if [ -n "${1}" ] && [ "${1}" != "." ]; then
    kubectl config use-context "${1}"
else
    echo "Current context is \"$(kubectl config current-context)\"."
fi

# set namespace from $2
if [ -n "${2}" ]; then
    kubectl config set-context --current --namespace="${2}" > /dev/null
    echo "Namespace \"${2}\" was set."
else
    echo "Current namespace is \"$(kubectl config get-contexts $(kubectl config current-context) --no-headers | awk '{print $5}')\"."
fi

# show context map at the end
if [ $# -eq 0 ] && [ -z "$KUBECTX_SILENT" ]; then
    FORMAT="%-1s %-30s %-15s"
    printf "$FORMAT\n" " " "NAME" "NAMESPACE"
    kubectl config get-contexts --no-headers | sed -E 's|/[a-zA-Z0-9]+||g' | sed -e 's|^ |-|g' | while IFS='$\n' read -r line; do
        current=$(echo "$line" | awk '{print $1}')
        [ "$current" != "*" ] && current=" "
        cluster=$(echo "$line" | awk '{print $2}')
        namespace=$(echo "$line" | awk '{print $5}')
        printf "$FORMAT\n" "$current" "$cluster" "$namespace"
    done
fi
