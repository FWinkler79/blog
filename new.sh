#!/bin/bash
echo "Usage: $0 <site name>"

docker run --rm \
  --volume="$PWD:/srv/jekyll" \
  -it jekyll/builder:latest \
  jekyll new $1