#! /bin/sh

ENV_DIR="$1"
ENVIRONMENT="$2"

# Add additional template to env template
cat "$ENV_DIR/additional" >> "$ENV_DIR/env"

ENV_VARS="$ENV_DIR/env"
RELEASE="$ENV_DIR/release"
DEV="$ENV_DIR/dev"
JSON=`cat $ENV_VARS | yq . | jq .`

echo "$JSON" > process.json

if [ $ENVIRONMENT = "release" ]; then
  cat $RELEASE | yq . | jq . > release.json
  NEW_JSON=`jq -rs 'reduce .[] as $item ({}; . * $item)' process.json release.json`
  echo "$NEW_JSON" > process.json
fi

if expr "$ENVIRONMENT" : "dev" 1>/dev/null; then
  cat $DEV | yq . | jq . > dev.json
  NEW_JSON=`jq -rs 'reduce .[] as $item ({}; . * $item)' process.json dev.json`
  echo "$NEW_JSON" > process.json
fi


node server.js
