#! /bin/sh

ENV_DIR="$1"
OVERLAY="$2"

ENV_VARS="$ENV_DIR/env"
RELEASE="$ENV_DIR/release"
DEV="$ENV_DIR/dev"
JSON=`cat $ENV_VARS | yq .`

if [ $OVERLAY = "release" ]; then
  echo "$JSON" > env.json
  cat $RELEASE | yq . > release.json
  JSON=`jq -rs 'reduce .[] as $item ({}; . * $item)' env.json release.json`
fi

if [ $OVERLAY = "dev" ]; then
  echo "$JSON" > env.json
  cat $DEV | yq . > dev.json
  JSON=`jq -rs 'reduce .[] as $item ({}; . * $item)' env.json dev.json`
fi

echo "window.env = $JSON" > env.js

cat env.js

cp env.js /usr/share/nginx/html/static/js && nginx -g "daemon off;"
