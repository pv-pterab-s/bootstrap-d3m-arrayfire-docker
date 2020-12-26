#!/bin/bash
# -*- compile-command: "./run.sh"; -*-
set -ex

D3M_DIR=$(pwd)/out

docker run \
       -it \
       --rm \
       -v $D3M_DIR/datasets:/mnt/datasets \
       -v $D3M_DIR/d3m-arrayfire-primitives:/mnt/d3m-arrayfire-primitives \
       arrayfire-d3m \
       /bin/bash -c "cd /mnt/d3m-arrayfire-primitives/af_primitives && $*"
