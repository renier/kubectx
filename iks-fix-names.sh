#!/bin/bash
for bad_name in $(kubectl config get-contexts -o name | grep '/'); do
    good_name=$(echo -n "${bad_name}" | cut -d '/' -f 1)
    kubectl config rename-context "${bad_name}" "${good_name}"
done
