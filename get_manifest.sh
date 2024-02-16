#!/bin/bash
set -e

git fetch

# try to get the manifest from the gh-pages branch
git checkout origin/gh-pages manifest.json

# create the prev_run_state directory if it doesn't exist
if [ ! -d "calcula_apagones/prev_run_state" ]; then
  mkdir calcula_apagones/prev_run_state
fi

# copy the manifest.json to the target directory
cp manifest.json calcula_apagones/prev_run_state/manifest.json
