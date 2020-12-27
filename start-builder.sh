#!/bin/bash
# -*- compile-command: "./start-builder.sh"; -*-
set -ex

D3M_DIR=$(pwd)/out
[ -d "$D3M_DIR" ]

docker run -it --rm \
       -v $D3M_DIR/datasets:/mnt/datasets \
       -v $D3M_DIR/d3m-arrayfire-primitives:/mnt/d3m-arrayfire-primitives \
       -v $D3M_DIR/..:/mnt/bootstrap-d3m-arrayfire-docker \
       arrayfire-d3m \
       bash -c 'cd /mnt/bootstrap-d3m-arrayfire-docker && bash -i'
