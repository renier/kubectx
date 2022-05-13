#!/bin/bash
set -e
current_context="$(kubectl config current-context)"
user_str="$(kubectl config view | yq e ".contexts[] | select(.name == \"${current_context}\") | .context.user" - )"
if [[ "$user_str" == "admin/"* ]]; then
	echo "can't do this with a satellite cluster"
	exit 1
fi
account_id="$(echo "$user_str" | cut -d '/' -f 2)"
current_login_account_id="$(jq -rM '.Account.GUID' ~/.bluemix/config.json)"
last_login="$(jq -rM '.LoginAt' ~/.bluemix/config.json | cut -c1-22,24-)"

days_ago="$(date -v-2d "+%Y-%m-%dT%H:%M:%S%z")"

# if [ "${account_id}" != "${current_login_account_id}" ] || [ "$last_login" < "$days_ago" ]; then
	ibmcloud login -a cloud.ibm.com --no-region --apikey "$(cat ~/Box/cloud_keys/${account_id}.json | jq -r '.apikey')"
# fi
iksconfig ${current_context}
