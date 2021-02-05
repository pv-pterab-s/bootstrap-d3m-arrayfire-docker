#!/bin/bash
# -*- compile-command: "./0-build-d3m-dir.sh"; -*-
# Usage: ./build-d3m-dir.sh [dir]
# Populates [dir] with required dirs for d3m + arrayfire development
#   - Optional [dir] defaults to $(pwd)/out
#   - /datasets populated with minimal "baseball" set
#   - pushes editable packages to out _and_ out/context
#     - Dockerfile builds the packages at out/context first so that
#       they can be used in the docker and also overriden with filesystem
#       mappings
set -ex

D3M_DIR=$(pwd)/out
if [ -n "$1" ]; then D3M_DIR="$1"; fi
mkdir -p $D3M_DIR

export GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
function clone-if-missing {
    local REPO_URL="$1"
    local REPO_NAME="$2"
    if ! [ -d "$D3M_DIR/$REPO_NAME" ]; then
        git clone --recursive $REPO_URL $D3M_DIR/$REPO_NAME
    fi
}
clone-if-missing https://github.com/pv-pterab-s/d3m-arrayfire-primitives d3m-arrayfire-primitives
(cd $D3M_DIR/d3m-arrayfire-primitives && git checkout square-one)
clone-if-missing https://github.com/pv-pterab-s/af-scikit-learn af-scikit-learn
(cd $D3M_DIR/af-scikit-learn && git checkout main)
if [ -n "$ONLY_ARRAYFIRE_D3M" ]; then echo only cloned d3m-arrayfire-primitives and af-scikit-learn; exit 0; fi


wget --continue https://gpryor-arrayfire.s3.amazonaws.com/datasets.baseball.tar.bz2 -O $D3M_DIR/datasets.baseball.tar.bz2
rm -rf $D3M_DIR/datasets
BYTES=$(stat -c '%s' $D3M_DIR/datasets.baseball.tar.bz2)
(cd $D3M_DIR && pv -pterab -s $BYTES datasets.baseball.tar.bz2 | tar xj)

clone-if-missing https://gitlab.com/datadrivendiscovery/d3m d3m

clone-if-missing https://gitlab.com/datadrivendiscovery/primitives primitives
(cd $D3M_DIR/primitives && git checkout v2020.1.24)


mkdir -p $D3M_DIR/pipeline-outputs
