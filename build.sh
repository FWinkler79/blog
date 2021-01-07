docker run --rm \
  --volume="$PWD:/srv/jekyll" \
  -it jekyll/builder:latest \
  jekyll build