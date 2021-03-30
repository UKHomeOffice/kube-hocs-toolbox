#!/bin/bash
set -euo pipefail

export KUBE_NAMESPACE=${ENVIRONMENT}
export KUBE_SERVER=${KUBE_SERVER}
export KUBE_TOKEN=${KUBE_TOKEN}
export REPLICAS="1"
export AWS_ACCOUNT_ID="449472082214"
export CLUSTER_NAME="acp-notprod"

if [[${KUBE_NAMESPACE} != "hocs-delta" &&
     ${KUBE_NAMESPACE} != "hocs-gamma" &&
     ${KUBE_NAMESPACE} != "hocs-qax"]]; then
    echo "Can only deploy to hocs-delta, hocs-gamma or hocs-qax" > /dev/termination-log;
    exit 1;
fi

echo
echo "Deploying toolbox to ${ENVIRONMENT}"
echo

export KUBE_CERTIFICATE_AUTHORITY="https://raw.githubusercontent.com/UKHomeOffice/acp-ca/master/${CLUSTER_NAME}.crt"

kd --timeout 10m \
    -f ./kube/hocs-toolbox.yaml
