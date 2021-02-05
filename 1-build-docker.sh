#!/bin/bash
# -*- compile-command: "./1-build-docker.sh"; -*-
set -ex

D3M_DIR=$(pwd)/out
[ -d "$D3M_DIR" ]

if ! [ -d "out/context/d3m-arrayfire-primitives" ]; then
    ONLY_ARRAYFIRE_D3M=true ./0-build-d3m-dir.sh out/context
fi
cp $(pwd)/Dockerfile $(pwd)/out/context/Dockerfile
docker build -t arrayfire-d3m out/context

docker run \
       --rm \
       -v $D3M_DIR/datasets:/mnt/datasets \
       -v $D3M_DIR/d3m-arrayfire-primitives:/mnt/d3m-arrayfire-primitives \
       -v $D3M_DIR/af-scikit-learn:/mnt/af-scikit-learn \
       arrayfire-d3m \
       /bin/bash -c "pip3 install -e /mnt/af-scikit-learn && pip3 install -e /mnt/d3m-arrayfire-primitives"
