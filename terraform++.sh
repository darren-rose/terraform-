#!/bin/bash

if [ $# -eq 0 ]; then
    echo "usage: $0 apply or destroy etc."
    exit 1
fi

command=$1
autoapprove=""
if [ "$command" = "apply" ] || [ "$command" = "destroy" ]; then
    autoapprove="--auto-approve"
fi

orderfile="order-create.txt"
if [ "$command" = "destroy" ]; then
    orderfile="order-destroy.txt"
fi

BASE_PATH=$(pwd)

while IFS= read -r folder || [ -n "$folder" ]; do
    if [ -z $folder ]; then
        continue
    fi
    echo ""
    echo "-------------------------- running terraform $command in ${folder}--------------------------"
    terraform -chdir=${BASE_PATH}/${folder} init
    terraform -chdir=${BASE_PATH}/${folder} $command $autoapprove || { echo "Failed running terraform ${TF_COMMAND} in ${folder}" ; exit 1; }
done < "${BASE_PATH}/$orderfile"
