#! /bin/bash

CUSTOM_ENV_FILES=("k8s/kustomize/$APP/overlays/$OVERLAY/$OVERLAY.yaml" "k8s/kustomize/$APP/overlays/$OVERLAY/kustomization.yaml")
DEV_PT_TO_STAGING_FILES=("k8s/kustomize/$APP/overlays/$OVERLAY/kustomization.yaml" "k8s/kustomize/$APP/overlays/$OVERLAY/service.yaml")

### DEV POINTING TO STAGING:
if [[ $OVERLAY = "dev-pt-to-staging" ]]; then
  for file in "${DEV_PT_TO_STAGING_FILES[@]}"
  do
    echo "Replacing PR_NUMBER variable in $file..."
    sed -i "s~{{ PR_NUMBER }}~$PR_NUMBER~g" $file
  done
else
  ### ALL OTHER ENVS NEED BASE:
  echo "Replacing IMAGE variable in deployment.yaml and cronjob.yaml (if it exists)..."
  sed -i "s~{{ IMAGE }}~$IMAGE~g" k8s/kustomize/$APP/base/deployment.yaml
  sed -i "s~{{ IMAGE }}~$IMAGE~g" k8s/kustomize/$APP/cronjobs/cronjob.yaml

  echo "Replacing NAMESPACE variable in deployment.yaml, hpa.yaml and cronjob.yaml (if it exists)..."
  sed -i "s~{{ NAMESPACE }}~$NAMESPACE~g" k8s/kustomize/$APP/base/deployment.yaml
  sed -i "s~{{ NAMESPACE }}~$NAMESPACE~g" k8s/kustomize/$APP/base/hpa.yaml
  sed -i "s~{{ NAMESPACE }}~$NAMESPACE~g" k8s/kustomize/$APP/cronjobs/cronjob.yaml

  echo "Replacing OVERLAY variable in deployment.yaml if need be..."
  sed -i "s~{{ OVERLAY }}~$OVERLAY~g" k8s/kustomize/$APP/base/deployment.yaml
fi

### RELEASE OR DEV:
if [[ $OVERLAY = "release" || $OVERLAY = "dev" ]]; then
  echo "Replacing API_URL, REACT_URL in k8s/kustomize/$APP/overlays/$OVERLAY/$OVERLAY.yaml..."
  sed -i "s~{{ API_URL }}~$API_URL~g" k8s/kustomize/$APP/overlays/$OVERLAY/$OVERLAY.yaml
  sed -i "s~{{ MP_URL }}~$REACT_URL~g" k8s/kustomize/$APP/overlays/$OVERLAY/$OVERLAY.yaml
fi

### DEV:
if [[ $OVERLAY = "dev" ]]; then
  for file in "${CUSTOM_ENV_FILES[@]}"
  do
    echo "Replacing PR_NUMBER variable in $file..."
    sed -i "s~{{ PR_NUMBER }}~$PR_NUMBER~g" $file
  done
fi
