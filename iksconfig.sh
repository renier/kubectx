#!/bin/bash
orig_ns=$(kubectl config view --minify --output 'jsonpath={..namespace}')
orig_ctx=$(kubectl config current-context)

set -eo pipefail
cluster_name="${1}"

if [ -z "${cluster_name}" ]; then
	echo "Getting the clusters you have access to..."
	NAMES=($(ibmcloud ks cluster ls -q | awk '{print $1}'))

	[ -z "$NAMES" ] && echo "No clusters found" && exit 1

	echo
	echo "Choose the cluster you want to log in to:"
	i=0
	for name in ${NAMES[@]}; do
		i=$((i+1))
		echo "${i}. $name"
	done
	read p

  p=$((p-1))
  cluster_name="${NAMES[$p]}"
fi

echo "Logging into the $cluster_name cluster..."
cluster_info="$(ibmcloud ks cluster get -c $cluster_name --output json)"
if echo "${cluster_info}" | grep '"openshift"'; then
	admin_opt="--admin"
fi
ibmcloud ks cluster config -c $cluster_name ${admin_opt} || exit 1

ctx=$(kubectl config current-context)
set +e
kubectl config delete-context "${cluster_name}" 2> /dev/null
set -eo pipefail
kubectl config rename-context "${ctx}" "${cluster_name}"
# recover/set expected namespace
if [ -n "${2}" ]; then
	kubectl config set-context --current --namespace="${2}" > /dev/null
elif [ "${cluster_name}" = "${orig_ctx}" ]; then
	kubectl config set-context --current --namespace="${orig_ns}" > /dev/null
fi
echo "Done."
