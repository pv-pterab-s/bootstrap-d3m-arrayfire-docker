#!/bin/bash
# -*- compile-command: "./prime-af.sh"; -*-
set -e

D3M_DIR=$(pwd)/out
mkdir -p $D3M_DIR

# assume build-d3m-dir.sh already run
docker run \
       --rm \
       -v $D3M_DIR:/mnt \
       arrayfire-d3m \
       /bin/bash -c "pip3 install -e /mnt/af-scikit-learn && pip3 install -e /mnt/d3m-arrayfire-primitives"
