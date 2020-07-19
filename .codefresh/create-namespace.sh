#! /bin/bash

apt-get update && apt-get install jq -y

kubectl config use-context $KUBE_CONTEXT

kubectl get namespace $NAMESPACE > /dev/null
EXITCODE=$?

if [ $EXITCODE -eq 1 ]; then
  kubectl create namespace $NAMESPACE
else
  echo "Namespace $NAMESPACE exists. Skipping creation..."
fi


kubectl get secret vault-addr --namespace staging -o json | jq '.metadata.namespace = "'$NAMESPACE'"' | kubectl create --namespace $NAMESPACE -f -

kubectl get secret vault-staging-tls-certificate --namespace staging -o json | jq '.metadata.namespace = "'$NAMESPACE'"' | kubectl create --namespace $NAMESPACE -f -
