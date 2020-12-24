#!/bin/bash
# -*- compile-command: "./prime-af.sh"; -*-
set -e

D3M_DIR=$(pwd)/out
if [ -n "$1" ]; then D3M_DIR="$1"; fi
mkdir -p $D3M_DIR

# assume build-d3m-dir.sh already run
docker run \
       --rm \
       -v $D3M_DIR/datasets:/mnt/datasets \
       -v $D3M_DIR/d3m-arrayfire-primitives:/mnt/d3m-arrayfire-primitives \
       arrayfire-d3m \
       /bin/bash -c "pip3 install -e /mnt/d3m-arrayfire-primitives"
