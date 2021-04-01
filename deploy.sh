#!/bin/bash
set -euo pipefail

export KUBE_NAMESPACE=${ENVIRONMENT}
export KUBE_TOKEN=${KUBE_TOKEN}
export REPLICAS="1"
export AWS_ACCOUNT_ID="449472082214"
export CLUSTER_NAME="acp-notprod"
export KUBE_SERVER="https://kube-api-notprod.notprod.acp.homeoffice.gov.uk"

export VALID_NAMESPACES=("hocs-gamma" "hocs-delta" "hocs-qax")
if [[ ${VALID_NAMESPACES[*]} =~ $KUBE_NAMESPACE ]] ; then
   echo "Passed namespace check"
else
   echo "Can only deploy to ${VALID_NAMESPACES[@]}" | tee /dev/termination-log;
   exit 1
fi

echo
echo "Deploying toolbox to ${ENVIRONMENT}"
echo

export KUBE_CERTIFICATE_AUTHORITY="https://raw.githubusercontent.com/UKHomeOffice/acp-ca/master/${CLUSTER_NAME}.crt"

kd --timeout 10m \
    -f ./kube/hocs-toolbox.yaml
