#!/bin/bash
echo "Usage: $0"

SCRIPT_DIR=$(dirname "$0")        # get the path of this script
SCRIPT_DIR=$(cd $SCRIPT_DIR; pwd) # get the full path

export JEKYLL_VERSION=3.8
docker run --rm \
  --volume="$PWD:/srv/jekyll" \
  --volume="$SCRIPT_DIR/cache:/usr/local/bundle" \
  -it jekyll/builder:$JEKYLL_VERSION \
  jekyll build