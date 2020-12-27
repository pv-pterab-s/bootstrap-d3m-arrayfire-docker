#!/bin/bash
# -*- compile-command: "./run.sh"; -*-
set -ex

if [ -n "$SCREEN_NAME" ]; then
    screen -p $SCREEN_NAME -S af -X stuff "$*\n"
    exit
fi

D3M_DIR=$(pwd)/out
[ -d "$D3M_DIR" ]

docker run --rm \
       -v $D3M_DIR/datasets:/mnt/datasets \
       -v $D3M_DIR/d3m-arrayfire-primitives:/mnt/d3m-arrayfire-primitives \
       -v $D3M_DIR/..:/mnt/bootstrap-d3m-arrayfire-docker \
       arrayfire-d3m \
       bash -c 'cd /mnt/bootstrap-d3m-arrayfire-docker && echo start && python3.6 run.py && echo stop'
